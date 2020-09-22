#!/bin/bash

INFRA_PROJECT=efactoryefsinfra

# run infrastructure
if [[ "$1" = "keycloack" ]]; then

        docker-compose -f keycloack/docker-compose.yml --project-name ${INFRA_PROJECT} up --build -d
elif [[ "$1" = "asg importer" ]]; then

	docker-compose -f asg-importer/docker-compose.yml --project-name ${INFRA_PROJECT} up --build -d
elif [[ "$1" = "apisix" ]]; then

	docker-compose -f api-security-gateway/docker-compose.yml --project-name ${INFRA_PROJECT} up -d
else
    echo "Invalid usage"
    exit 2

fi
