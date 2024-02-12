REGISTRY=us-central1-docker.pkg.dev/lab-terraform-414113
APP_NAME=comments-api
BRANCH_NAME=main
SHORT_SHA=$(shell git log --format="%h" -n 1)

build:
	docker build -t ${REGISTRY}/${APP_NAME}/${BRANCH_NAME}:${SHORT_SHA} .

push:
	docker push ${REGISTRY}/${APP_NAME}/${BRANCH_NAME}:${SHORT_SHA}