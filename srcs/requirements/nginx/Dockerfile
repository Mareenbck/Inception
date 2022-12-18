FROM	debian:buster

# RUN		apt update
# RUN		apt install nginx -y
# RUN		apt install vim -y
# RUN		apt install curl -y
# RUN		apt install openssl -y
RUN apt-get update -y && apt-get install -y \
		nginx \
		openssl
RUN		mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/mbascuna.key -out /etc/nginx/ssl/mbascuna.crt \
	-subj "/C=FR/ST=Paris/L=Paris/O=42Paris/OU=mbascuna.42.fr/CN=mbascuna.42.fr"

COPY	conf/nginx.conf /etc/nginx/nginx.conf

RUN			chown -R www-data:www-data /var/www/html
RUN			chmod 755 /var/www/html
CMD		[ "nginx", "-g", "daemon off;" ]
EXPOSE	443
