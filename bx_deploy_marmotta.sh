# create local docker image
docker build -t nimbleplatform/marmotta-backend --build-arg DB_HOST=marmotta-db --build-arg DB_PORT=5432 --build-arg DB_USER=root --build-arg DB_PASS=changeme .

# push to docker hub
docker push nimbleplatform/marmotta-backend

# add to Bluemix container registry
bx ic cpi nimbleplatform/marmotta-backend registry.eu-gb.bluemix.net/semantic_mediator_container/marmotta-backend

# run postgres container
bx ic run --name marmotta-db -e "POSTGRES_PASSWORD=changeme" -e "POSTGRES_USER=root" -e "POSTGRES_DB=marmotta" -p 5432:5432  -m 128 registry.eu-gb.bluemix.net/semantic_mediator_container/postgre

# run marmotta
bx ic run --name marmotta-backend --link marmotta-db:marmotta-db -p 8080:8080 -m 256 registry.eu-gb.bluemix.net/semantic_mediator_container/marmotta-backend