FROM	debian:buster

RUN		apt-get update -y && apt-get install -y \
		mariadb-server 

COPY 	conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

COPY 	tools/script.sh /script.sh

ENTRYPOINT ["bash", "script.sh"]

EXPOSE 3306
