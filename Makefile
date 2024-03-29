## Meta data about the image
DOCKER_IMAGE=dsuite/alpine-nginx
DOCKER_IMAGE_CREATED=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
DOCKER_IMAGE_REVISION=$(shell git rev-parse --short HEAD)

## Current directory
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

## Define the latest version
latest = 1.25

## Config
.DEFAULT_GOAL := help
.PHONY: *

help: ## Display this help!
	@printf "\n\033[33mUsage:\033[0m\n  make \033[32m<target>\033[0m \033[36m[\033[0marg=\"val\"...\033[36m]\033[0m\n\n\033[33mTargets:\033[0m\n"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

build-all: ## Build all supported versions
	@$(MAKE) build v=1.16
	@$(MAKE) build v=1.17
	@$(MAKE) build v=1.18
	@$(MAKE) build v=1.19
	@$(MAKE) build v=1.20
	@$(MAKE) build v=1.21
	@$(MAKE) build v=1.22
	@$(MAKE) build v=1.23
	@$(MAKE) build v=1.24
	@$(MAKE) build v=1.25

test-all: ## Build all supported versions
	@$(MAKE) test v=1.16
	@$(MAKE) test v=1.17
	@$(MAKE) test v=1.18
	@$(MAKE) test v=1.19
	@$(MAKE) test v=1.20
	@$(MAKE) test v=1.21
	@$(MAKE) test v=1.22
	@$(MAKE) test v=1.23
	@$(MAKE) test v=1.24
	@$(MAKE) test v=1.25

push-all: ## Push all supported versions
	@$(MAKE) push v=1.16
	@$(MAKE) push v=1.17
	@$(MAKE) push v=1.18
	@$(MAKE) push v=1.19
	@$(MAKE) push v=1.20
	@$(MAKE) push v=1.21
	@$(MAKE) push v=1.22
	@$(MAKE) push v=1.23
	@$(MAKE) push v=1.24
	@$(MAKE) push v=1.25

build: ## Build ( usage : make build v=1.25 )
	$(eval version := $(or $(v),$(latest)))
	@docker run --rm \
		-e NGINX_VERSION=$(version) \
		-e DOCKER_IMAGE_CREATED=$(DOCKER_IMAGE_CREATED) \
		-e DOCKER_IMAGE_REVISION=$(DOCKER_IMAGE_REVISION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(version)"
	@docker build --force-rm \
		--build-arg GH_TOKEN=${GH_TOKEN} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(version) \
		--tag $(DOCKER_IMAGE):$(version) \
		$(DIR)/Dockerfiles
	@[ "$(version)" = "$(latest)" ] && docker tag $(DOCKER_IMAGE):$(version) $(DOCKER_IMAGE):latest || true

test: ## Test ( usage : make test v=1.25 )
	$(eval version := $(or $(v),$(latest)))
	@GOSS_FILES_PATH=$(DIR)/tests \
	GOSS_SLEEP=0.5 \
	 	dgoss run $(DOCKER_IMAGE):$(version)

push: ## Push ( usage : make push v=1.25 )
	$(eval version := $(or $(v),$(latest)))
	@docker push $(DOCKER_IMAGE):$(version)
	@[ "$(version)" = "$(latest)" ] && docker push $(DOCKER_IMAGE):latest || true

shell: ## Run shell ( usage : make shell v=1.25 )
	$(eval version := $(or $(v),$(latest)))
	@$(MAKE) build v=$(version)
	@docker run -it --rm --init \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):$(version) \
		bash

remove: ## Remove all generated images
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{} || true
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 3 | xargs -I {} docker rmi {} || true

readme: ## Generate docker hub full description
	@docker run -t --rm \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
