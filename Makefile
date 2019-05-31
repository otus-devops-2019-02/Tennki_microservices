# import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

APPS = comment post ui cloudprober prometheus mongodb-exporter
COMMENT_PATH = $(APP_DIR)/comment
POST_PATH = $(APP_DIR)/post-py
UI_PATH = $(APP_DIR)/ui
COMMENT_DEP = $(shell echo $(shell find $(COMMENT_PATH) -type f))
POST_DEP = $(shell echo $(shell find $(POST_PATH) -type f))
UI_DEP = $(shell echo $(shell find $(UI_PATH) -type f))
COMMENT_VERSION = $(shell head -n 1 $(COMMENT_PATH)/VERSION)
POST_VERSION = $(shell head -n 1 $(POST_PATH)/VERSION)
UI_VERSION = $(shell head -n 1 $(UI_PATH)/VERSION)

CLOUDPROBER_PATH = $(MONITORING_DIR)/cloudprober
PROMETHEUS_PATH = $(MONITORING_DIR)/prometheus
MONGO_EXPORTER_PATH = $(MONITORING_DIR)/mongodb-exporter
CLOUDPROBER_DEP = $(shell echo $(shell find $(CLOUDPROBER_PATH) -type f))
PROMETHEUS_DEP = $(shell echo $(shell find $(PROMETHEUS_PATH) -type f))
MONGO_EXPORTER_DEP = $(shell echo $(shell find $(MONGO_EXPORTER_PATH) -type f))

# HELP
# This will output the help for each task
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help


# DOCKER TASKS
# Build docker images
build: build-comment build-post build-ui build-cloudprober build-prometheus build-mongodb-exporter ## Build all docker images

build-comment: $(COMMENT_DEP) ## Build comment image
	docker build -t $(DOCKER_REPO)/comment $(COMMENT_PATH)

build-post: $(POST_DEP)## Build post image
	docker build -t $(DOCKER_REPO)/post $(POST_PATH)

build-ui: $(UI_DEP) ## Build ui image
	docker build -t $(DOCKER_REPO)/ui $(UI_PATH)

build-cloudprober: $(CLOUDPROBER_DEP) ## Build cloudprober image
	docker build -t $(DOCKER_REPO)/cloudprober $(CLOUDPROBER_PATH)

build-prometheus: $(PROMETHEUS_DEP) ## Build prometheus image
	docker build -t $(DOCKER_REPO)/prometheus $(PROMETHEUS_PATH)

build-mongodb-exporter: $(MONGO_EXPORTER_DEP) ## Build mondo-exporter image
	docker build -t $(DOCKER_REPO)/mongodb-exporter $(MONGO_EXPORTER_PATH)

release: build publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to Docker Hub

# Docker publish
publish: repo-login publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers to Docker Hub

publish-latest: repo-login ## Publish the `latest` taged container to Docker HubDocker Hub
	@echo 'publish latest to $(DOCKER_REPO)'
	for app in $(APPS); do \
		docker push $(DOCKER_REPO)/$${app}:latest; \
	done
publish-version: repo-login tag ## Publish the `{version}` taged container to Docker Hub
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/comment:$(COMMENT_VERSION)
	docker push $(DOCKER_REPO)/post:$(POST_VERSION)
	docker push $(DOCKER_REPO)/ui:$(UI_VERSION)

tag: ## Generate container tag
	@echo 'create comment tag $(COMMENT_VERSION)'
	docker tag $(DOCKER_REPO)/comment $(DOCKER_REPO)/comment:$(COMMENT_VERSION)
	@echo 'create post tag $(POST_VERSION)'
	docker tag $(DOCKER_REPO)/post $(DOCKER_REPO)/post:$(POST_VERSION)
	@echo 'create ui tag $(UI_VERSION)'
	docker tag $(DOCKER_REPO)/ui $(DOCKER_REPO)/ui:$(UI_VERSION)


# Login to Docker Hub
repo-login: ## Login to Docker Hub
	test -s $(DOCKER_REPO_CRED) && cat $(DOCKER_REPO_CRED) | docker login --username $(DOCKER_REPO) --password-stdin || docker login --username $(DOCKER_REPO)
	
	
