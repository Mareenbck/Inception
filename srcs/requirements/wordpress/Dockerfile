FROM	debian:buster

ARG		PHP_VERSION=7.3
RUN		apt-get update -y && apt-get upgrade -y
RUN 	apt-get -y install curl \
		mariadb-client \
		php${PHP_VERSION} \
		php${PHP_VERSION}-fpm \
		php${PHP_VERSION}-curl \
		php${PHP_VERSION}-mysql \
		php${PHP_VERSION}-mbstring \
		php${PHP_VERSION}-xml \
		php${PHP_VERSION}-zip \
		php${PHP_VERSION}-gd \
		php${PHP_VERSION}-imap

RUN		mkdir -p /var/www/html ; mkdir -p /run/php

RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/local/bin/wp

COPY	./conf/php.conf /etc/php/7.3/fpm/pool.d/www.conf

COPY	tools/init.sh /init.sh
EXPOSE	9000

ENTRYPOINT ["bash", "init.sh"]

CMD ["php-fpm7.3", "-F"]

