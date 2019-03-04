#!/bin/bash

# run infrastructure
if [[ "$1" = "infra" ]]; then

	docker-compose -f infra/docker-compose-prod.yml --project-name nimbleinfra-prod up --build -d

elif [[ "$1" = "services" ]]; then

	# start services
	docker-compose -f services/docker-compose-prod.yml \
		--project-name nimbleservices-prod up \
		-d \
		--build \
		--force-recreate \
		identity-service business-process-service frontend-service catalog-service-srdc frontend-service-sidecar

elif [[ "$1" = "keycloak" ]]; then

	docker-compose -f infra/keycloak/docker-compose-prod.yml --project-name nimbleinfra-prod up --build -d

elif [[ "$1" = "marmotta" ]]; then

	docker-compose -f infra/marmotta/docker-compose-marmotta.yml --project-name nimbleinfra-prod pull
	docker-compose -f infra/marmotta/docker-compose-marmotta.yml --project-name nimbleinfra-prod up --build -d

elif [[ "$1" = "solr" ]]; then

	docker-compose -f infra/solr/docker-compose.yml --project-name nimbleinfra-prod up -d

elif [[ "$1" = "elk" ]]; then

	docker-compose -f infra/elk-prod/docker-compose-elk.yml --project-name nimbleinfra-prod up --build -d

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

	docker-compose -f infra/keycloak/docker-compose-prod.yml --project-name nimbleinfra-prod up --build --force-recreate -d

elif [[ "$1" = "keycloak-logs" ]]; then

	docker-compose -f infra/keycloak/docker-compose-prod.yml --project-name nimbleinfra-prod logs -f

else
    echo "Invalid usage"
    exit 2
fi
