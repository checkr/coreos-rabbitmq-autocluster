ORG ?= checkr
RABBITMQ_VERSION ?= 3.6.6
PLUGIN_BASE ?= v3.6.x
AUTOCLUSTER_VERSION ?= 0.6.1
DELAYED_MESSAGE_VERSION ?= 0.0.1
MESSAGE_TIMESTAMP_VERSION ?= 3.6.x-3195a55a

.PHONY:	build
build:
	docker build \
		--build-arg RABBITMQ_VERSION=${RABBITMQ_VERSION} \
		--build-arg PLUGIN_BASE=${PLUGIN_BASE} \
		--build-arg AUTOCLUSTER_VERSION=${AUTOCLUSTER_VERSION} \
		--build-arg DELAYED_MESSAGE_VERSION=${DELAYED_MESSAGE_VERSION} \
		--build-arg MESSAGE_TIMESTAMP_VERSION=${MESSAGE_TIMESTAMP_VERSION} \
	-t $(ORG)/rabbitmq-autocluster:$(RABBITMQ_VERSION) .

.PHONY:	push
push:
	docker push $(ORG)/rabbitmq-autocluster:$(RABBITMQ_VERSION) 

.PHONY: gen
gen:
	cat cloudformation.tpl.json | sed -e "s/##USERDATA##/$(shell cat ./cloud-config.yml | base64 -i -)/g" > cloudformation.json
