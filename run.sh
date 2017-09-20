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
		--force-recreate business-process-service frontend-service catalog-service-srdc frontend-service-sidecar
		# --force-recreate identity-service business-process-service frontend-service catalog-service-srdc frontend-service-sidecar

elif [[ "$1" = "start" ]]; then

	update_images
	start_all

elif [[ "$1" = "start-no-update" ]]; then

	start_all

elif [[ "$1" = "stop" ]]; then
	
	docker-compose -f services/docker-compose.yml --project-name nimbleservices stop
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra stop

elif [[ "$1" = "restart-single" ]]; then

	docker-compose -f services/docker-compose.yml \
		--project-name nimbleservices up \
		--build \
		--force-recreate $2

elif [[ "$1" = "down" ]]; then
	
	docker-compose -f services/docker-compose.yml --project-name nimbleservices down
	docker-compose -f infra/docker-compose.yml --project-name nimbleinfra down

elif [[ "$1" = "services-logs" ]]; then

	docker-compose -f services/docker-compose.yml --project-name nimbleservices logs -f
	
else
    echo Usage: $0 COMMAND
    echo Commands:
    echo "  infrastructure to start only infastructure components"
    echo "  services to start actual services"
    echo "  start to start everything"
    echo "  stop to stop everything"
    exit 2
fi
