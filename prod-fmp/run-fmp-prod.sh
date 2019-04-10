#!/bin/bash

INFRA_PROJECT=nimbleinfra-fmp-prod
SERVICE_PROJECT=nimbleservices-fmp-prod

# run infrastructure
if [[ "$1" = "infra" ]]; then

	docker-compose -f infra/docker-compose-prod-fmp.yml --project-name ${INFRA_PROJECT} up --build -d

elif [[ "$1" = "database" ]]; then

	docker-compose -f infra/docker-compose-prod-fmp.yml --project-name ${INFRA_PROJECT} up -d fmp-main-db

elif [[ "$1" = "keycloak" ]]; then

	docker-compose -f infra/keycloak/docker-compose-prod-fmp.yml --project-name ${INFRA_PROJECT} up --build -d

elif [[ "$1" = "solr" ]]; then

	docker-compose -f infra/solr/docker-compose.yml --project-name ${INFRA_PROJECT} up -d

elif [[ "$1" = "marmotta" ]]; then

	docker-compose -f infra/marmotta/docker-compose-marmotta-prod-fmp.yml --project-name ${INFRA_PROJECT} pull
	docker-compose -f infra/marmotta/docker-compose-marmotta-prod-fmp.yml --project-name ${INFRA_PROJECT} up --build -d

elif [[ "$1" = "services" ]]; then

	# update services
	docker-compose -f services/docker-compose-prod-fmp.yml --project-name ${SERVICE_PROJECT} pull

	# start services
	docker-compose -f services/docker-compose-prod-fmp.yml --project-name ${SERVICE_PROJECT} up \
		-d \
		--build \
		identity-service business-process-service frontend-service  catalogue-service frontend-service-sidecar \
		search-service data-aggregation-service trust-service

elif [[ "$1" = "start" ]]; then

	update_images
	start_all

elif [[ "$1" = "restart-single" ]]; then

	# update services
	docker-compose -f services/docker-compose-prod-fmp.yml --project-name ${SERVICE_PROJECT} pull $2

	# restart service
	docker-compose -f services/docker-compose-prod-fmp.yml --project-name ${SERVICE_PROJECT} up --build -d --force-recreate $2

elif [[ "$1" = "service-logs" ]]; then

	docker-compose -f services/docker-compose-prod-fmp.yml --project-name ${SERVICE_PROJECT} logs -f $2

elif [[ "$1" = "services-logs" ]]; then

	docker-compose -f services/docker-compose-prod-fmp.yml --project-name ${SERVICE_PROJECT} logs -f

else
    echo "Invalid usage"
    exit 2
fi
