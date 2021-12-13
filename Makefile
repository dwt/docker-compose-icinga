# Ease switching to podman
DOCKER = docker
DOCKER_COMPOSE = docker-compose

# Provide same environment variable that docker-compose ues
include .env

.DEFAULT:
just-run-the-damn-thing: update start
	
.PHONY:
podman:
	# switch to using podman and podman-compose
	$(eval DOCKER=podman)
	$(eval DOCKER_COMPOSE=podman-compose)
	# ensure podman is able to resolve dns queries
	$(eval export GODEBUG:=netdns=go)

.PHONY:
start: fix-permissions
	$(DOCKER_COMPOSE) up -d

.PHONY:
stop:
	$(DOCKER_COMPOSE) down

.PHONY:
logs:
	# Doesn't work with podman-compose yet
	$(DOCKER_COMPOSE) logs --follow

.PHONY:
fix-permissions:
	-which podman && podman unshare chown -R 5665:5665 icinga2
	-which podman && podman unshare chown -R 33:33 icingaweb
	# I don't remember actively touching this config - check if this is really neccessary
	# -which podman && podman unshare chown -R 33:33 icingaweb

.PHONY:
update: fix-permissions
	$(DOCKER_COMPOSE) build --pull

.PHONY:
pull: fix-permissions
	# update container images
	$(DOCKER_COMPOSE) pull

.PHONY:
clean:
	$(DOCKER) system prune --all --force

.PHONY:
icinga-recreate-cert:
	$(DOCKER_COMPOSE) run --rm icinga2 icinga2 node wizard

.PHONY:
icinga-config-check: 
	$(DOCKER_COMPOSE) run --rm icinga2 icinga2 daemon --validate

.PHONY:
icinga-config-reload: 
	$(DOCKER_COMPOSE) exec icinga2 pkill -HUP icinga2

.PHONY:
icinga-shell: 
	$(DOCKER_COMPOSE) run --rm --user root icinga2 bash

.PHONY:
icinga-config-print: 
	$(DOCKER_COMPOSE) exec icinga2 icinga2 object list

.PHONY:
icinga-service-json:
	$(DOCKER_COMPOSE) exec icinga2 curl --insecure --silent --user root:$(ICINGA_API_ROOT_PASWORD) https://localhost:5665/v1/objects/services |jq

