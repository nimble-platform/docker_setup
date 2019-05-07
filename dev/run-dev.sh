#!/bin/bash

update_images () { 
	# update infrastructure
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra pull

	# update services
	docker-compose -f services/docker-compose.yml --project-name nimbleservices pull

}

start_all () {
	# start infrastructure
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra up -d --build --remove-orphans

	# wait for gateway proxy (last service started before)
	echo "*****************************************************************"
	echo "******************* Stalling for Gateway Proxy ******************"
	echo "*****************************************************************"
	docker run --rm --net=nimbleinfra_default -it mcandre/docker-wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries 60 gateway-proxy:80/info

	# start services
	docker-compose -f services/docker-compose.yml --project-name nimbleservices up -d --build --remove-orphans

	echo "*****************************************************************"
	echo "********************* Stalling for services *********************"
	echo "*****************************************************************"
	docker run --rm --net=nimbleinfra_default -it mcandre/docker-wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries 30 frontend-service:8080
	docker run --rm --net=nimbleinfra_default -it mcandre/docker-wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries 30 identity-service:9096/info
	docker run --rm --net=nimbleinfra_default -it mcandre/docker-wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries 30 catalog-service-srdc:8095/info
	docker run --rm --net=nimbleinfra_default -it mcandre/docker-wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries 30 business-process-service:8085/info
}

# run infrastructure
if [[ "$1" = "infrastructure" ]]; then

	if [[ "$2" != "--no-updates" ]]; then
		update_images
	fi

	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra up --build

elif [[ "$1" = "services" ]]; then

	if [[ "$2" != "--no-updates" ]]; then
		update_images
	fi

	# start services
	docker-compose -f services/docker-compose.yml \
		--project-name nimbleservices up \
		--build \
        --force-recreate identity-service business-process-service frontend-service catalog-service frontend-service-sidecar trust-service indexing-service

#    docker-compose -f services/docker-compose.yml --project-name nimbleservices up --build --force-recreate identity-service

elif [[ "$1" = "start" ]]; then

	update_images
	start_all

elif [[ "$1" = "start-no-update" ]]; then

	start_all

elif [[ "$1" = "stop" ]]; then
	
	docker-compose -f services/docker-compose.yml --project-name nimbleservices stop
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra stop

elif [[ "$1" = "down" ]]; then

	read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        docker-compose -f services/docker-compose.yml --project-name nimbleservices down -v
	    docker-compose -f infra/docker-compose.yml --project-name nimbleinfra down -v
    fi

elif [[ "$1" = "stop-services" ]]; then
	
	docker-compose -f services/docker-compose.yml --project-name nimbleservices stop

elif [[ "$1" = "restart-single" ]]; then

	docker-compose -f services/docker-compose.yml \
		--project-name nimbleservices up \
		--build \
		--no-deps \
		-d \
		--force-recreate $2

	docker-compose -f services/docker-compose.yml \
		--project-name nimbleservices \
		logs -f $2

elif [[ "$1" = "down" ]]; then
	
	docker-compose -f services/docker-compose.yml --project-name nimbleservices down --remove-orphans -v
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra down --remove-orphans -v

elif [[ "$1" = "services-logs" ]]; then
	
	docker-compose -f services/docker-compose.yml --project-name nimbleservices logs -f

elif [[ "$1" = "cloud-infra" ]]; then

	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra up -d --build --force-recreate config-server service-discovery gateway-proxy
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra logs -f config-server service-discovery gateway-proxy

elif [[ "$1" = "keycloak" ]]; then

	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra up -d --build --force-recreate keycloak
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra logs -f keycloak keycloak-db

elif [[ "$1" = "dev-infra" ]]; then

	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra up -d --build --force-recreate kafka maildev solr dev-main-db
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra logs -f kafka maildev solr dev-main-db

elif [[ "$1" = "create-network" ]]; then

    docker network create nimbleinfra_default

else
    echo Usage: $0 COMMAND
    echo Commands:
    echo "  infrastructure   start only infrastructure components"
    echo "  services         start nimble core services"
    echo "  start            start infrastructure and core services"
    echo "  start-no-update  start infrastructure and core services, without updating the images"
    echo "  restart-single SERVICE  restart a single core service"
    echo "  stop             stop infrastructure and core services"
    echo "  stop-services    stop core services, but leave infrastructure running"
    echo "  down             stop and remove everything (incl. volumes)"
    echo "  services-logs    get the log output from the nimble core services"
    exit 2
fi
