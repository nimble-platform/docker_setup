#!/bin/bash

# run infrastructure
if [[ "$1" = "infra" ]]; then

	docker-compose -f infra/docker-compose-staging.yml --project-name nimbleinfra-staging up --remove-orphans --build -d

elif [[ "$1" = "services" ]]; then

	# start services
	docker-compose -f services/docker-compose-staging.yml \
		--project-name nimbleservices-staging up \
		-d \
		--build \
		--force-recreate \
		identity-service business-process-service frontend-service catalog-service-srdc frontend-service-sidecar

elif [[ "$1" = "start" ]]; then

	update_images
	start_all

elif [[ "$1" = "restart-single" ]]; then

	docker-compose -f services/docker-compose-staging.yml \
		--project-name nimbleservices-staging up \
		--build \
		-d \
		--force-recreate $2

#	docker-compose -f services/docker-compose-staging.yml \
#		--project-name nimbleservices-staging \
#		logs -f $2

elif [[ "$1" = "services-logs" ]]; then

	docker-compose -f services/docker-compose-staging.yml --project-name nimbleservices-staging logs -f
	
else
    echo "Invalid usage"
    exit 2
fi
