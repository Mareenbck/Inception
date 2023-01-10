FROM	debian:buster

ARG		PHP_VERSION=7.3
RUN		apt-get update -y && apt-get upgrade -y
RUN 	apt-get -y install curl \
		#pour utiliser mysqladmin
		mariadb-client \
		#php pour utiliser wordpress
		php${PHP_VERSION} \
		php${PHP_VERSION}-fpm \
		php${PHP_VERSION}-curl \
		php${PHP_VERSION}-mysql \
		php${PHP_VERSION}-mbstring \
		php${PHP_VERSION}-xml \
		php${PHP_VERSION}-zip \
		php${PHP_VERSION}-gd \
		php${PHP_VERSION}-imap

#creer dossier qui permet a wordpress et php de se lancer
RUN		mkdir -p /var/www/html ; mkdir -p /run/php

# Installer WP-CLI = WordPress command line interface + rendre le fichier executable avec chmod et le deplacer dans le bin
RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/local/bin/wp

# Copier le fichier de configuration
COPY	./conf/php.conf /etc/php/7.3/fpm/pool.d/www.conf

COPY	tools/init.sh /init.sh
EXPOSE	9000

ENTRYPOINT ["bash", "init.sh"]

# Command launched at the end of the setup
CMD ["php-fpm7.3", "-F"]
# php-fpm7.3 [--help]
# -F, --nodaemonize 			: force to stay in foreground and ignore daemonize option from config file
# -R, --allow-to-run-as-root	: Allow pool to run as root (disabled by default)
