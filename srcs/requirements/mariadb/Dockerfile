FROM		debian:buster

RUN			apt-get update -y && apt-get install -y \
			mariadb-server \
			mariadb-client

# Create MySQL service directory
# Give MySQL user and group permission to work with the created directory
RUN			mkdir -p /run/mysqld /var/lib/mysql && \
			chown -R mysql:mysql /run/mysqld /var/lib/mysql

# mysql_install_db inits the database and creates a 'root@localhost' account with no initial password set
RUN			mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal --skip-test-db

COPY		./conf/my.cnf /etc/mysql/my.cnf
COPY 		tools/script.sh /script.sh

ENTRYPOINT 	["bash", "script.sh"]

EXPOSE 		3306

CMD 		["/usr/bin/mysqld_safe", "--datadir=/var/lib/mysql"]


