DEPS += .env
DEPS += secrets/db_pass.txt
DEPS += secrets/db_root_pass.txt

DEV_ARGS := -f docker-compose.yml -f docker-compose-dev.yml

STACK_ARGS := -c docker-compose.yml -c docker-compose-swarm.yml
STACK_NAME = ca

################################################################################

.PHONY: default
default:
	@echo "usage: make <ACTION>"
	@echo ""
	@echo "DEV ACTIONS"
	@echo "  up"
	@echo "  upd"
	@echo "  down"
	@echo "  full-down"
	@echo "  ps"
	@echo ""
	@echo "DEPLOY ACTIONS"
	@echo "  deploy"
	@echo "  rm"
	@echo "  info"
	@echo "  show"
	@echo "  logs SERVICE=<NAME>"
	@echo ""

################################################################################
# Dev actions

.PHONY: up
up: $(DEPS)
	@docker-compose $(DEV_ARGS) up --build

.PHONY: upd
upd: $(DEPS)
	@docker-compose $(DEV_ARGS) up --build -d

.PHONY: down
down: $(DEPS)
	@docker-compose $(DEV_ARGS) down

.PHONY: full-down
full-down: $(DEPS)
	@docker-compose $(DEV_ARGS) down -v

.PHONY: ps
ps: $(DEPS)
	@docker-compose $(DEV_ARGS) ps

################################################################################
# Depoy actions

.PHONY: deploy
deploy: $(DEPS)
	@source ./.env && docker stack deploy $(STACK_ARGS) $(STACK_NAME)

.PHONY: info
info:
	@docker stack services $(STACK_NAME)

.PHONY: show
show:
	@docker stack ps $(STACK_NAME)

.PHONY: logs
logs:
	@docker service logs $(STACK_NAME)_$(SERVICE)

.PHONY: rm
rm:
	@docker stack rm $(STACK_NAME)

################################################################################

.PHONY: setup
setup:
	@bash ./setup.sh

.env: setup

secrets/db_pass.txt: setup

secrets/db_root_pass.txt: setup
