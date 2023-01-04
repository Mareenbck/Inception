#!/bin/sh

echo "COUCOU"
if [ ! -f /var/www/html/wp-config.php ]; then

	cd /var/www/html

	wp core download --allow-root

	until mysqladmin --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --host=mariadb ping; do
		sleep 2
	done

	echo "Creation d'un fichier de configuration Wordpress avec User Mysql"
	wp config create	--dbname=${MYSQL_DATABASE} \
						--dbuser=${MYSQL_USER} \
						--dbpass=${MYSQL_PASSWORD} \
						--dbhost=mariadb \
						--allow-root
	echo "OK"

	echo "Installation de Wordpress "
	wp core install		--url=localhost \
						--title="Inception" \
						--admin_user=${WP_ADMIN_LOGIN} \
						--admin_password=${WP_ADMIN_PASSWORD} \
						--admin_email=${WP_ADMIN_EMAIL} \
						--skip-email \
						--allow-root
	echo "OK"

	echo "Creation d'un second user"
	wp user create 		${WP_USER_LOGIN} ${WP_USER_EMAIL} \
						--user_pass=${WP_USER_PASSWORD} \
						--role=author \
						--allow-root
	echo "OK"

	echo "Installation du theme"
	wp theme install astra --activate --allow-root
	echo "OK"
	# wp theme install twentytwentyone --activate

fi;


echo "Starting PHP-FPM..."
exec "$@"
# exec php-fpm7.3 -F -R
