# #!/bin/sh

# service mysql start;

# mysql -e "CREATE DATABASE IF NOT EXISTS '${MYSQL_DATABASE}';"

# mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# mysql -e "GRANT ALL PRIVILEGES ON '${MYSQL_DATABASE}'.* TO \'${MYSQL_USER}'@'%' IDENTIFIED BY \'${MYSQL_PASSWORD}';"

# mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# mysql -e "FLUSH PRIVILEGES;"

# mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# exec mysqld_safe


# #!/bin/bash

# DATABASE_DIR=/var/lib/mysql/${MYSQL_DATABASE}

# if [ ! -d "$DATABASE_DIR" ]; then

# 	# Launch mariadb server in background
# 	/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

# 	# We check whether the server is available
# 	# The return status from mysqladmin is 0 if the server is running, 1 if it is not
# 	until mysqladmin ping 2> /dev/null; do
# 		sleep 2
# 	done

# 	# Connexion to the database:
# 	# We :	- create the database
# 	# 		- set the root password
# 	#		- disable remote access for root user and delete the empty user
# 	# 		- create a simple user and give him rights (use of '%' instead of 'localhost' to allow him remote-access)
# 	# 		- refresh the privileges

# 	mysql -u root << EOF

# 	CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

# 	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

# 	DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
# 	DELETE FROM mysql.user WHERE user='';

# 	CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# 	GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

# 	FLUSH PRIVILEGES;

# EOF

# 	# Shutdown the server because we need to restart it
# 	killall mysqld 2> /dev/null

# fi

# # We execute the CMD of the Dockerfile ["mysqld_safe"] --> relaunch the database
# exec "$@"

#!/bin/sh

if [ ! -d /var/lib/mysql/wordpress ]
then

	echo "Starting temporary server..."
	cd '/usr' ; /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
	# mysqld &
	# while ! mysqladmin ping -hlocalhost &>/dev/null; do
	# 	sleep 2
  	# done
	# sleep 3
	until mysqladmin ping 2> /dev/null; do
		sleep 2
	done
	echo "Creating Wordpress database..."
	mysql -u root <<- _EOF_
		CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
		CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
	_EOF_
	echo "Wordpress database created!"

	echo "Securing the MYSQL installation..."
	mysql -u root <<- _EOF_
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		DELETE FROM mysql.user WHERE User='';
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
		FLUSH PRIVILEGES;
	_EOF_
	echo "MYSQL installation secured!"

	echo "Stopping temporary server!"
	mysqladmin --user=root --password=$MYSQL_ROOT_PASSWORD shutdown

	sleep 3
fi

echo "Starting mariadb server..."
# exec mariadbd --user=root
exec "$@"

