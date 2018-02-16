#!/bin/bash

INFRA_PROJECT=nimbleinfra-staging
SERVICE_PROJECT=nimbleservices-staging

# run infrastructure
if [[ "$1" = "infra" ]]; then

	docker-compose -f infra/docker-compose.yml --project-name ${INFRA_PROJECT} up --remove-orphans --build -d

elif [[ "$1" = "keycloak" ]]; then

	docker-compose -f infra/keycloak/docker-compose.yml --project-name ${INFRA_PROJECT} up --build -d

elif [[ "$1" = "marmotta" ]]; then

	docker-compose -f infra/marmotta/docker-compose-marmotta.yml --project-name ${INFRA_PROJECT} pull
	docker-compose -f infra/marmotta/docker-compose-marmotta.yml --project-name ${INFRA_PROJECT} up --build -d

elif [[ "$1" = "elk" ]]; then

	docker-compose -f infra/elk/docker-compose-elk.yml --project-name ${INFRA_PROJECT} up --build -d

elif [[ "$1" = "services" ]]; then

	# update services
	docker-compose -f services/docker-compose.yml --project-name ${SERVICE_PROJECT} pull

	# start services
	docker-compose -f services/docker-compose.yml --project-name ${SERVICE_PROJECT} up \
		-d \
		--build \
		--force-recreate \
		identity-service business-process-service frontend-service catalog-service-srdc frontend-service-sidecar

elif [[ "$1" = "start" ]]; then

	update_images
	start_all

elif [[ "$1" = "restart-single" ]]; then

	# update services
	docker-compose -f services/docker-compose.yml --project-name ${SERVICE_PROJECT} pull $2

	# restart service
	docker-compose -f services/docker-compose.yml \
		--project-name nimbleservices-staging up \
		--build \
		-d \
		--force-recreate $2

elif [[ "$1" = "services-logs" ]]; then

	docker-compose -f services/docker-compose.yml --project-name nimbleservices-staging logs -f
	
else
    echo "Invalid usage"
    exit 2
fi
