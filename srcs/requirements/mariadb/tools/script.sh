#!/bin/sh

if [ ! -d /var/lib/mysql/wordpress ]
then

	echo "Starting temporary server..."
	cd '/usr' ; /usr/bin/mysqld_safe --datadir=/var/lib/mysql &

	until mysqladmin ping 2> /dev/null; do
		sleep 2
	done
	
	echo "Creation de la database Wordpress..."
	mysql -u root <<- _EOF_
		CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
		CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
	_EOF_
	echo "Ok"

	echo "MYSQL installation..."
	mysql -u root <<- _EOF_
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		DELETE FROM mysql.user WHERE User='';
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
		FLUSH PRIVILEGES;
	_EOF_
	echo "Ok"

	echo "Stopping temporary server!"
	mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown

	sleep 3
fi

echo "Starting mariadb server..."
exec "$@"

