#!/bin/sh

if [ ! -d /var/lib/mysql/wordpress ]
then

	echo "Starting temporary server..."
	mariadbd --user=root &

	sleep 3

	echo "Creating Wordpress database..."
	mysql --user=root <<- _EOF_
		CREATE DATABASE $MARIADB_DATABASE;
		CREATE USER '$MARIADB_LOGIN'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
		GRANT ALL ON $MARIADB_DATABASE.* TO '$MARIADB_LOGIN'@'%';
		FLUSH PRIVILEGES;
	_EOF_
	echo "Wordpress database created!"

	echo "Securing the MYSQL installation..."
	mysql --user=root <<- _EOF_
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';
		DELETE FROM mysql.user WHERE User='';
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
		FLUSH PRIVILEGES;
	_EOF_
	echo "MYSQL installation secured!"

	echo "Stopping temporary server!"
	mysqladmin --user=root --password=$MARIADB_ROOT_PASSWORD shutdown

	sleep 3
fi

echo "Starting mariadb server..."
exec mariadbd --user=root


FROM debian:buster

RUN	apt-get update && \
	apt-get install -y \
	mariadb-server \
	mariadb-client

# Create MySQL service directory
RUN	mkdir -p /run/mysqld /var/lib/mysql && \
# Give MySQL user and group permission to work with the created directory
	chown -R mysql:mysql /run/mysqld /var/lib/mysql

# mysql_install_db inits the database and creates a 'root@localhost' account with no initial password set
RUN	mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal --skip-test-db

# We enable remote-access to the database in the configuration file my.cnf
COPY ./conf/my.cnf /etc/mysql/my.cnf
# equivalent to the command --> RUN sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# MariaDB installation script is imported in /usr/local/bin to be executed as entrypoint
COPY ./tools/setup_mariadb.sh /usr/local/bin/

# Serves only as documentation here
EXPOSE 3306

ENTRYPOINT ["setup_mariadb.sh"]

# Command launched at the end of the setup
CMD ["/usr/bin/mysqld_safe", "--datadir=/var/lib/mysql"]


FROM alpine:3.15

RUN apk update \
	&& apk add mysql mysql-client

RUN mkdir run/mysqld

RUN mysql_install_db --user=root --datadir=/var/lib/mysql

COPY mariadb-server.cnf etc/my.cnf.d/

COPY init.sh .
RUN chmod +x init.sh

CMD ["./init.sh"]
