#!/usr/bin/env bash

# Wait for the Elasticsearch container to be ready before starting Kibana.
echo "Stalling for Elasticsearch"
wget --quiet --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 --tries inf http://elasticsearch:9200/

echo "Starting Kibana"
exec kibana
