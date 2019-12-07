DOCKER_IMAGE=dsuite/alpine-nginx
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))


build: build-1.16 build-1.17

test: test-1.16 test-1.17

push: push-1.16 push-1.17

build-1.16:
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NGINX_VERSION=1.16 \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-1.16"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-1.16 \
		--tag $(DOCKER_IMAGE):1.16 \
		$(DIR)/Dockerfiles

build-1.17:
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NGINX_VERSION=1.17 \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-1.17"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-1.17 \
		--tag $(DOCKER_IMAGE):1.17 \
		$(DIR)/Dockerfiles
	@docker tag $(DOCKER_IMAGE):1.17 $(DOCKER_IMAGE):latest


test-1.16: build-1.16
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run -e NGINX_VERSION=1.16 --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):1.16

test-1.17: build-1.17
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run -e NGINX_VERSION=1.17 --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):1.17

push-1.16: build-1.16
	@docker push $(DOCKER_IMAGE):1.16

push-1.17: build-1.17
	@docker push $(DOCKER_IMAGE):1.17
	@docker push $(DOCKER_IMAGE):latest

shell-1.16: build-1.16
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-v $(DIR):/data \
		$(DOCKER_IMAGE):1.16 \
		bash

shell-1.17: build-1.17
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e PHP_FPM_ENABLE=0 \
		-v $(DIR):/data \
		$(DOCKER_IMAGE):1.17 \
		bash

remove:
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{}

readme:
	@docker run -t --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
