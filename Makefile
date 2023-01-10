NAME					= inception
DOCKER_COMPOSE_FILE		= ./srcs/docker-compose.yml
HOME					= /home/mbascuna
DATABASE_VOLUME			= $(HOME)/data/mariadb_volume
WORDPRESS_VOLUME		= $(HOME)/data/wordpress_volume
DATABASE_DOCKER_VOLUME	= srcs_mariadb_volume
WORDPRESS_DOCKER_VOLUME	= srcs_wordpress_volume

all:	inception

${NAME}: build up

build:
		docker-compose -f $(DOCKER_COMPOSE_FILE) build

volume:
		sudo rm -rf $(HOME)/data
		sudo mkdir -p $(DATABASE_VOLUME)
		sudo mkdir -p $(WORDPRESS_VOLUME)

up:
		docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --remove-orphans

down:
		docker-compose -f $(DOCKER_COMPOSE_FILE) down

logs:
		docker-compose -f $(DOCKER_COMPOSE_FILE) logs

clean:	down
		docker container prune --force

fclean:	clean
		sudo rm -rf $(DATABASE_VOLUME)
		sudo rm -rf $(WORDPRESS_VOLUME)
		docker system prune --all --force --volumes
		docker network prune --force
		docker volume prune --force
		docker volume rm $(DATABASE_DOCKER_VOLUME) $(WORDPRESS_DOCKER_VOLUME)

re:		fclean all

.PHONY:	all volume up down clean fclean re





