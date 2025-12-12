NAME = inception
COMPOSE_FILE = ./srcs/docker-compose.yml
DB_VOLUME_PATH = /home/${USER}/data/mariadb
WP_VOLUME_PATH = /home/${USER}/data/wordpress

all: up

up:
	@mkdir -p $(DB_VOLUME_PATH)
	@mkdir -p $(WP_VOLUME_PATH)
	@docker compose -f $(COMPOSE_FILE) -p $(NAME) up -d

down:
	@docker compose -f $(COMPOSE_FILE) -p $(NAME) down

stop:
	@docker compose -f $(COMPOSE_FILE) -p $(NAME) stop

start:
	@docker compose -f $(COMPOSE_FILE) -p $(NAME) start

logs:
	@docker compose -f $(COMPOSE_FILE) -p $(NAME) logs

ps:
	@docker compose -f $(COMPOSE_FILE) -p $(NAME) ps

clean: down
	docker volume rm $$(docker volume ls -q)
	docker image rm $$(docker image ls -q)

fclean: clean
	@sudo rm -rf $(DB_VOLUME_PATH)
	@sudo rm -rf $(WP_VOLUME_PATH)

re: fclean all

.PHONY: all up build down stop start logs ps clean fclean re
