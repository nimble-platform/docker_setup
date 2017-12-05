#!/usr/bin/env bash


# run infrastructure
if [[ "$1" = "deploy" ]]; then
    docker-compose -f docker-compose-marmotta.yml pull
    docker-compose -f docker-compose-marmotta.yml --project-name nimbleinfra-prod up -d --force-recreate
fi

