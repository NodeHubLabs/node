.PHONY: build build-dev build-images clean push build-single

DIRS := $(shell find . -type f \( -name 'Dockerfile' -o -name 'Dockerfile.*' \) -exec dirname {} \; | sort | uniq)

USERNAME := nodehublabs

build: 
	@$(MAKE) build-images SUFFIX=""

build-dev:
	@$(MAKE) build-images SUFFIX="-dev"

build-images:
	@echo "Directories: $(DIRS)"
	@for dir in $(DIRS); do \
		$(MAKE) build-dir DIR=$$dir SUFFIX=$(SUFFIX); \
	done

build-single:
	@$(MAKE) build-dir DIR=$(DIR) SUFFIX=$(SUFFIX)

build-dir:
	$(eval IMAGE_NAME = $(shell cat $(DIR)/VERSION | grep IMAGE_NAME | cut -d '=' -f2))
	$(eval IMAGE_TAG = $(shell cat $(DIR)/VERSION | grep IMAGE_TAG | cut -d '=' -f2)$(SUFFIX))
	@echo "Building Docker image in directory $(DIR)"
	@cd $(DIR) && docker buildx build --platform linux/amd64 -t $(USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) .
	@cd $(DIR) && docker tag $(USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) $(USERNAME)/$(IMAGE_NAME):latest$(SUFFIX)
	@$(MAKE) push DIR=$(DIR) USERNAME=$(USERNAME) IMAGE_NAME=$(IMAGE_NAME) IMAGE_TAG=$(IMAGE_TAG) SUFFIX=$(SUFFIX)

push:
	@echo "Pushing to Docker Hub as $(USERNAME)"
	$(eval CONFIG_PATH = $(shell echo ~/.docker/$(USERNAME)_config))
	@DOCKER_CONFIG=$(CONFIG_PATH) docker push $(USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	@DOCKER_CONFIG=$(CONFIG_PATH) docker push $(USERNAME)/$(IMAGE_NAME):latest$(SUFFIX)

clean:
	@echo "Clean up not implemented"