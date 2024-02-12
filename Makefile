DOCKER_REGISTRY=${REGISTRY}/${PROJECT_ID}
APP_NAME=comments-api
BRANCH_NAME=${shell git symbolic-ref --short HEAD}
SHORT_SHA=$(shell git log --format="%h" -n 1)

build:
	docker build -t ${DOCKER_REGISTRY}/${APP_NAME}/${BRANCH_NAME}:${SHORT_SHA} .

push:
	docker push ${DOCKER_REGISTRY}/${APP_NAME}/${BRANCH_NAME}:${SHORT_SHA}