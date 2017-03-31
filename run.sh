#!/bin/bash

update_images () { 
	# update infrastructure
	docker-compose -f infra/docker-compose.yml -f infra/uaa/docker-compose.yml --project-name nimbleinfra pull

	# update services
	docker-compose -f services/docker-compose.yml --project-name nimbleservices pull

}

# run infrastructure
if [ "$1" = "infrastructure" ]; then

	update_images
	docker-compose -f infra/docker-compose.yml -f infra/uaa/docker-compose.yml --project-name nimbleinfra up --build --force-recreate

elif [ "$1" = "services" ]; then

	update_images
	docker-compose -f services/docker-compose.yml --project-name nimbleservices up --build --force-recreate

elif [ "$1" = "start" ]; then

	update_images

	# start infrastructure
	docker-compose -f infra/docker-compose.yml -f infra/uaa/docker-compose.yml --project-name nimbleinfra up -d --build --force-recreate

	# wait for gateway proxy (last service started before)
	echo "Stalling for Gateway Proxy"
	docker run --rm --net=nimbleinfra_default -it mcandre/docker-wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 --tries 60 gateway-proxy:80

	# start services
	docker-compose -f services/docker-compose.yml --project-name nimbleservices up --build --force-recreate

elif [ "$1" = "stop" ]; then
	
	docker-compose -f services/docker-compose.yml --project-name nimbleservices down
	docker-compose -f infra/docker-compose.yml -f infra/uaa/docker-compose.yml --project-name nimbleinfra down
	
else
    echo Usage: $0 COMMAND
    echo Commands:
    echo "\tinfrastructure\tto start only infastructure components"
    echo "\tservices\tto start actual services"
    echo "\tstart\t\tto start everything"
    echo "\tstop\t\tto stop everything"
    exit 2
fi
