FROM	debian:buster

RUN		apt update
RUN		apt install nginx -y
RUN		apt install vim -y
RUN		apt install curl -y
RUN		apt install openssl -y
RUN		mkdir -p /etc/nginx/ssl
RUN		openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=mbascuna.42.fr/UID=mbascuna"
RUN		mkdir -p /var/run/nginx

COPY	conf/nginx.conf /etc/nginx/nginx.conf

RUN		chmod 755 /var/www/html
RUN		chown -R www-data:www-data /var/www/html

# CMD		[ "nginx", "-g", "daemon off;" ]
