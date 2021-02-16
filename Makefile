# Ease switching to podman
DOCKER = docker
DOCKER_COMPOSE = docker-compose

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
	$(DOCKER_COMPOSE) logs --follow

.PHONY:
fix-permissions:
	# FIXME figure out what user these should belong to
	# -which podman && podman unshare chown -R 472:472 grafana/data
	# -which podman && podman unshare chown -R 1000:1000 elasticsearch

.PHONY:
update: fix-permissions
	$(DOCKER_COMPOSE) build --pull

.PHONY:
update-all-containers: fix-permissions
	# update container images
	$(DOCKER_COMPOSE) pull

.PHONY:
clean:
	$(DOCKER) system prune --all --force
