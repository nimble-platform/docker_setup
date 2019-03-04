#!/usr/bin/env bash

# run infrastructure
if [[ "$1" = "deploy" ]]; then
    docker-compose -f docker-compose-marmotta-prod-fmp.yml pull
    docker-compose -f docker-compose-marmotta-prod-fmp.yml --project-name nimbleinfra-fmp-prod up -d --force-recreate
fi

