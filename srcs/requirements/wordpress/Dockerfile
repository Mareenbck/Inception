FROM	debian:buster

RUN		apt-get update -y && apt-get upgrade -y
RUN 	apt-get -y install curl \
		#pour utiliser mysqladmin
		mariadb-client \
		#php pour utiliser wordpress
		php7.3 \
		php7.3-fpm \
		php7.3-curl \
		php7.3-mysql \
		php7.3-mbstring \
		php7.3-xml \
		php7.3-zip \
		php7.3-gd \
		php7.3-imap

#creer dossier qui permet a wordpress et php de se lancer
RUN		mkdir -p /var/www/html ; mkdir -p /run/php

# Installer WP-CLI = WordPress command line interface + rendre le fichier executable avec chmod et le deplacer dans le bin
RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/local/bin/wp

# Copier le fichier de configuration
COPY	./conf/php.conf /etc/php/7.3/fpm/pool.d/www.conf

# # Aller dans le dossier pour wordpress et telecharger wordpress
# RUN		cd /var/www/html && wp core download --allow-root
# RUN		chown -R root:root /var/www/html
COPY	tools/init.sh /init.sh
# COPY 	tools/init.sh /usr/local/bin/
EXPOSE	9000

ENTRYPOINT ["bash", "init.sh"]

# Command launched at the end of the setup
# CMD ["php-fpm7.3", "-F"]
# php-fpm7.3 [--help]
# -F, --nodaemonize 			: force to stay in foreground and ignore daemonize option from config file
# -R, --allow-to-run-as-root	: Allow pool to run as root (disabled by default)
