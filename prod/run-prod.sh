#!/bin/bash

update_images () { 
	# update infrastructure
	docker-compose -f infra/docker-compose-prod.yml --project-name nimbleinfra-prod pull

	# update services
	docker-compose -f services/docker-compose-prod.yml --project-name nimbleservices-prod pull

}

# run infrastructure
if [[ "$1" = "infra" ]]; then

	if [[ "$2" != "--no-updates" ]]; then
		update_images
	fi

	docker-compose -f infra/docker-compose-prod.yml --project-name nimbleinfra-prod up --remove-orphans --build -d

elif [[ "$1" = "services" ]]; then

	if [[ "$2" != "--no-updates" ]]; then
		update_images
	fi

	# start services
	docker-compose -f services/docker-compose-prod.yml \
		--project-name nimbleservices-prod up \
		-d \
		--build \
		--force-recreate \
		identity-service business-process-service frontend-service catalog-service-srdc frontend-service-sidecar

elif [[ "$1" = "start" ]]; then

	update_images
	start_all

elif [[ "$1" = "restart-single" ]]; then

	docker-compose -f services/docker-compose-prod.yml \
		--project-name nimbleservices-prod up \
		--build \
		-d \
		--force-recreate $2

#	docker-compose -f services/docker-compose-prod.yml \
#		--project-name nimbleservices-prod \
#		logs -f $2

elif [[ "$1" = "services-logs" ]]; then

	docker-compose -f services/docker-compose-prod.yml --project-name nimbleservices-prod logs -f

elif [[ "$1" = "infra-logs" ]]; then

	docker-compose -f infra/docker-compose-prod.yml --project-name nimbleinfra-prod logs -f

elif [[ "$1" = "keycloak" ]]; then

	docker-compose -f infra/keycloak/docker-compose-prod.yml --project-name nimbleinfra-prod-keyloak up --force-recreate -d

elif [[ "$1" = "keycloak-logs" ]]; then

	docker-compose -f infra/keycloak/docker-compose-prod.yml --project-name nimbleinfra-prod-keyloak logs -f

else
    echo "Invalid usage"
    exit 2
fi
