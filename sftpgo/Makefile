# The default make command.
APP = my-terraform
ORG = personal
DEFAULT = help
NAME = sftpgo
TAG = latest
PWD = $(shell pwd)

# Use 'VERBOSE=1' to echo all commands, for example 'make help VERBOSE=1'.
ifdef VERBOSE
  Q :=
else
  Q := @
endif

.PHONY: \ 
	build \ 
	run \
	stop \
	logs \
	deploy \
	create_app \
	push_to_fly \
	deploy_from_fly \
	help

all: $(DEFAULT)

help:
	$(Q)echo "Dev CLI - v0.0.1"
	$(Q)echo "make build             - Builds docker image" 
	$(Q)echo "make run               - Runs docker image"
	$(Q)echo "make stop              - Stops docker image"
	$(Q)echo "make logs              - Shows logs from docker image"
	$(Q)echo "make deploy            - Deploys docker image to fly.io"
	$(Q)echo "make push_to_fly       - Pushes docker image to fly.io"
	$(Q)echo "make deploy_from_fly   - Deploys docker image from fly.io"

build:
	docker build --no-cache -f Dockerfile -t $(NAME):$(TAG) .

run: 
	docker run --rm --name auto-sftpgo -p 8080:8080 -p 2022:2022  \
	--mount type=bind,source=$(PWD)/data,target=/data \
	$(NAME):$(TAG)

stop:
	docker stop $(NAME):$(TAG)

logs:
	docker logs $(NAME):$(TAG)

deploy:
	fly deploy

create_app:
	fly apps create --machines --org $(ORG) --name $(APP)

push_to_fly:
	fly deploy --app $(APP) --build-only --remote-only --image-label $(NAME)-$(TAG) --push

deploy_from_fly: 
	fly deploy --app $(APP) --image registry.fly.io/$(APP):$(NAME)-$(TAG) 