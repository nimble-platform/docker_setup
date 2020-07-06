#!/bin/bash

INFRA_PROJECT=efactoryefsinfra
SERVICE_PROJECT=efactoryefsinfra

# run infrastructure
if [[ "$1" = "infra" ]]; then

        docker-compose -f infra/docker-compose.yml --project-name ${INFRA_PROJECT} up --build -d
elif [[ "$1" = "restart-single" ]]; then

        # update services
        docker-compose -f service/docker-compose.yml --project-name ${SERVICE_PROJECT} pull $2

        # restart service
        docker-compose -f service/docker-compose.yml --project-name ${SERVICE_PROJECT} up --build -d --force-recreate $2

elif [[ "$1" = "keycloak" ]]; then

	docker-compose -f infra/keycloak/docker-compose.yml --project-name ${INFRA_PROJECT} up --build -d

elif [[ "$1" = "apisix" ]]; then

	docker-compose -f infra/apisix/docker-compose.yml --project-name ${INFRA_PROJECT} up -d

else
    echo "Invalid usage"
    exit 2

fi
