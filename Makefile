all: build push

build:
	docker build -t petergrace/aws-irsa-rds-postgres .

push:
	docker push petergrace/aws-irsa-rds-postgres:latest

