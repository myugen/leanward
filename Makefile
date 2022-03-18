PROJECT_ROOT:=.
DEBUG ?= 0

help:
	@echo "Please use \`make <target>\` where <target> is one of:"
	@echo "  <generic targets>:"
	@echo "  up                 to up a specific docker compose service, using the following variables:"
	@echo "                         - DOCKER_COMPOSE_FILE: set docker compose file to execute, default: docker-compose.yml"
	@echo "                         - SERVICE (required): set docker compose service to up"
	@echo "  run                to run a specific docker compose service, using the following variables:"
	@echo "                         - DOCKER_COMPOSE_FILE: set docker compose file to execute, default: docker-compose.yml"
	@echo "                         - PORTS (expanded): set ports to publish the running service, i.e: PORTS = \"80:80\" \"8080:8080\""
	@echo "                         - SERVICE (required): set docker compose service to run"
	@echo "                         - ARGS: set arguments to execute on running services, i.e: ARGS=python manage.py help"
	@echo "  logs               to log a specific docker compose service, using the following variables:"
	@echo "                         - DOCKER_COMPOSE_FILE: set docker compose file to execute, default: docker-compose.yml"
	@echo "                         - SERVICE (required): set docker compose service to log"
	@echo "  down               to down docker compose services, using the following variables:"
	@echo "                         - DOCKER_COMPOSE_FILE: set docker compose file to execute, default: docker-compose.yml"
	@echo ""
	@echo "  <\`services\` specific targets>:"
	@echo "  vault              to up the \`vault\` service with logs"
	@echo ""
	@echo "You can set DEBUG=1 flag to debug make execution"
.PHONY: help

up:
ifeq ($(DEBUG), 1)
	$(info Executing docker compose up command with following flags:)
	$(info   - DOCKER_COMPOSE_FILE: $(DOCKER_COMPOSE_FILE))
	$(info   - SERVICE: $(SERVICE))
endif
	@docker-compose -f $(or $(DOCKER_COMPOSE_FILE),docker-compose.yml) up -d $(SERVICE)
.PHONY: up

run:
ifeq ($(DEBUG), 1)
	$(info Executing docker compose run command with following flags:)
	$(info   - DOCKER_COMPOSE_FILE: $(DOCKER_COMPOSE_FILE))
	$(info   - PORTS: $(PORTS))
	$(info   - SERVICE: $(SERVICE))
	$(info   - ARGS: $(ARGS))
endif
	@docker-compose -f $(or $(DOCKER_COMPOSE_FILE),docker-compose.yml) run $(if $(PORTS), $(foreach port,$(PORTS),-p $(port))) --rm $(SERVICE) $(ARGS)
.PHONY: run

logs:
ifeq ($(DEBUG), 1)
	$(info Executing docker compose logs command with following flags:)
	$(info   - DOCKER_COMPOSE_FILE: $(DOCKER_COMPOSE_FILE))
	$(info   - SERVICE: $(SERVICE))
endif
	@docker-compose -f $(or $(DOCKER_COMPOSE_FILE),docker-compose.yml) logs -f --tail=500 $(SERVICE)
.PHONY: logs

down:
ifeq ($(DEBUG), 1)
	$(info Executing docker compose down command with following flags:)
	$(info   - DOCKER_COMPOSE_FILE: $(DOCKER_COMPOSE_FILE))
endif
	@docker-compose -f $(or $(DOCKER_COMPOSE_FILE),docker-compose.yml) down
.PHONY: down

vault: SERVICE=vault
vault: up logs
.PHONY: vault
