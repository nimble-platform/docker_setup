#!/bin/bash

BLUEMIX_REGISTRY=registry.eu-gb.bluemix.net/semantic_mediator_container

update_images () { 
	# update infrastructure
	docker-compose -f infra/docker-compose.yml -f infra/uaa/docker-compose-bluemix.yml --project-name nimbleinfra pull

	# update services
	docker-compose -f services/docker-compose-bluemix.yml --project-name nimbleservices pull

}

# run infrastructure
if [ "$1" = "infrastructure" ]; then

	update_images
	docker-compose -f infra/docker-compose-bluemix.yml -f infra/uaa/docker-compose-bluemix.yml --project-name nimbleinfra up --build --force-recreate

elif [ "$1" = "services" ]; then

	update_images
	docker-compose -f services/docker-compose-bluemix.yml --project-name nimbleservices up --build --force-recreate

elif [ "$1" = "start" ]; then

	update_images

	# start infrastructure
	docker-compose -f infra/docker-compose-bluemix.yml -f infra/uaa/docker-compose-bluemix.yml --project-name nimbleinfra up -d --build --force-recreate

	# wait for gateway proxy (last service started before)
	echo "Stalling for Gateway Proxy"
	docker run --rm --net=nimbleinfra_default -it mcandre/docker-wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries 60 gateway-proxy:80

	# start services
	docker-compose -f services/docker-compose-bluemix.yml --project-name nimbleservices up --build --force-recreate

elif [ "$1" = "stop" ]; then
	
	docker-compose -f services/docker-compose-bluemix.yml --project-name nimbleservices down
	docker-compose -f infra/docker-compose-bluemix.yml -f infra/uaa/docker-compose-bluemix.yml --project-name nimbleinfra down

elif [[ "$1" = "cpis" ]]; then
	
	# Copy images to Bluxmix registry

	# Databases
	bx ic cpi postgres $BLUEMIX_REGISTRY/postgre:latest

	# Microservice infrastructure images
	bx ic cpi nimbleplatform/config-server:latest $BLUEMIX_REGISTRY/nimble-config-server:latest
	bx ic cpi nimbleplatform/service-discovery:latest $BLUEMIX_REGISTRY/nimble-service-discovery:latest
	bx ic cpi nimbleplatform/gateway-proxy:latest $BLUEMIX_REGISTRY/nimble-gateway-proxy:latest
	bx ic cpi nimbleplatform/hystrix-dashboard:latest $BLUEMIX_REGISTRY/nimble-hystrix-dashboard:latest

	# UAA images
	bx ic cpi java:openjdk-8u66-jre $BLUEMIX_REGISTRY/nimble-java8-base:latest

	# Service images
	bx ic cpi nimbleplatform/identity-service:latest $BLUEMIX_REGISTRY/nimble-identity-service:latest
	bx ic cpi nimbleplatform/business-process-service:latest $BLUEMIX_REGISTRY/nimble-business-process-service:latest
	bx ic cpi nimbleplatform/catalogue-service-micro-srdc:latest $BLUEMIX_REGISTRY/nimble-business-process-service:latest


elif [[ "$1" = "machine-login" ]]; then

	eval "$(cf ic login | grep export)"
	echo "DOCKER_HOST=$DOCKER_HOST"
	echo "DOCKER_CERT_PATH=$DOCKER_CERT_PATH"
	echo "DOCKER_TLS_VERIFY=$DOCKER_TLS_VERIFY"

elif [[ "$1" = "machine-logout" ]]; then

	unset DOCKER_HOST
	unset DOCKER_CERT_PATH
	unset DOCKER_TLS_VERIFY
	
else
    echo Usage: $0 COMMAND
    echo Commands:
    echo "\tinfrastructure\tto start only infastructure components"
    echo "\tservices\tto start actual services"
    echo "\tstart\t\tto start everything"
    echo "\tstop\t\tto stop everything"
    exit 2
fi
