# Deployment Setup

The setup is split into to three configuration scenarios, whereas each scenario has 
a dedicated directory with the same name. The directory structure is as follows:

* `jenkins_ci`: setup for Jenkins CI
* `nginx`: setup and configuration for the webserver (i.e. nginx)
* `dev`: deployment setup for local development
* `staging`: 	deployment setup for staging environment
* `prod`: deployment setup used in production

Each deployment setup is composed of infrastructure componententes and 
the actual Microservices. A utility script with the name `run*.sh` can 
be found in the directories of each setup.

**Top Level Components**:

* **Nginx** is used a reverse proxy for each component.
	* **Configuration**: `nginx/docker-compose.yml`
	* **Nginx Configuration**: `nginx/nginx.conf`
	* **Manual Deployment**: `fab deploy logs -H <username>@<host>` (fabricate 
	
* **Jenkins** is used for continous integration.
	* **Configuration**: `jenkins_ci/docker-compose.yml`
	* **Docker File**: `jenkins_ci/Dockerfile`

## Productive Deployment

* Location: `prod`

In general the Platform is split into two different kind of components (1) infrastructure components (directory `infra`) and (2) microservice components (directory `services`).

### Infrastructure Components

These componentes are part of the virtual network with the name `nimbleinfraprod_default`. More information can be found bey executing `docker network inspect nimbleinfraprod_default` on the Docker host.

#### General Infrastructure

* Marmotta
	* **Configuration**: `prod/infra/docker-compose-marmotta.yml`
	* **Container Name**: nimbleinfraprod\_marmotta\_1 
* Keycloak
	* **Configuration**: `prod/keycloak/docker-compose-prod.yml`
	* **Container Name**: nimbleinfraprod\_keycloak\_1 
* ELK Stack
	* **Configuration**: `prod/elk-prod/docker-compose-elk.yml`
	* **Container Names**: nimbleinfraprod\_kibana\_1, nimbleinfraprod\_elasticsearch\_1, nimbleinfraprod\_logstash\_1

#### Microservice Infrastructure

Defintion can be found in `prod/services/docker-compose-prod.yml`, which consists of the following components:

* Config Server: 
	* **ServiceID**: config-server
	* **Container Name**: nimbleinfraprod\_config-server\_1

* Service Discovery: 
	* **ServiceID**: service-discovery
	* **Container Name**: nimbleinfraprod\_service-discovery\_1
	
* Gateway Proxy: 
	* **ServiceID**: gateway-proxy
	* **Container Name**: nimbleinfraprod\_gateway-proxy\_1

* Hystrix Dashboard (not used at the moment)
	* **ServiceID**: hystrix-dashboard

### Microservice Components:

Definition and configuration of the deployment can be found in `prod/services/docker-compose-prod.yml` and defines the follwing services:

* Identity Service
	* **ServiceID**: identity-service
	* **Container Name**: nimbleservicesprod\_identity-service\_1
* Business Process Service
	* **ServiceID**: business-process-service
	* **Container Name**: nimbleservicesprod\_business-process-service\_1
* Catalog Service
	* **ServiceID**: catalog-service-srdc
	* **Container Name**: nimbleservicesprod\_catalog-service-srdc\_1
* Frontend Service
	* **ServiceID**: frontend-service
	* **Container Name**: nimbleservicesprod\_frontend-service\_1
* Frontend Service Sidecar
	* **ServiceID**: frontend-service-sidecar
	* **Container Name**: nimbleservicesprod\_frontend-service-sidecar\_1

**Configuration** is done via environment variables, which are define in `prod/services/env_vars`. Secrets are stored in `prod/services/env_vars-prod` (this file is adapted on the hosting machine).

### Utility Script

A small utility script can be found in `run-prod.sh`, which provides the following functionalies:

* `run-prod.sh infra`: starts all infrastructure components 
* `run-prod.sh keycloak`: starts the Keycloak container
* `run-prod.sh marmotta`: starts the Marmotta container
* `run-prod.sh elk`: start all ELK components
* `run-prod.sh services`: starts all serivces (note: make sure the infastructue is set up appropriately)
* `run-prod.sh infra-logs`: print logs of all microservice components to stdout
* `run-prod.sh services-logs`: print logs of all services to stdout
* `run-prod.sh restart-single <serviceID>`: restart a single service

## Staging Deployment

* Location: `staging`

not yet active

## (Local) Docker Development Deployment

This section provides detailed information on how to set up a local development deployment using Docker. Required files are located in the `dev` directory.

 * `cd dev`

Recommended System Requirements (for Docker)
 * 16GB Memory
 * 4 CPUs

Minimum System Requirements (for Docker)
 * 10GB Memory / 2 CPUs

A utility script called `run-dev.sh` provides the following main commands:

* `run-dev.sh infrastructure`: starts all microservice infrastructure components
* `run-dev.sh services`: starts all nimble core services (note: make sure the infrastructue is running appropriately before)
* `run-dev.sh start`: starts infrastructure and services (not recommended at the first time)
* `run-dev.sh stop`: stop all services

It is recommended to start the infrastructure and the services in separate terminals for easier debugging.

### Starting microservice infrastructure

`./run-dev.sh infrastructure`: log output will be shown in the terminal

Before continuing to start services, check the infrastructure components as follows:
  * `docker ps` should show 7 new containers up and running:

```
$ docker ps --format 'table {{.Names}}\t{{.Ports}}'
NAMES                             PORTS
nimbleinfra_gateway-proxy_1       0.0.0.0:80->80/tcp
nimbleinfra_service-discovery_1   0.0.0.0:8761->8761/tcp
nimbleinfra_keycloak_1            0.0.0.0:8080->8080/tcp, 0.0.0.0:8443->8443/tcp
nimbleinfra_kafka_1               0.0.0.0:9092->9092/tcp
nimbleinfra_keycloak-db_1         5432/tcp
nimbleinfra_config-server_1       0.0.0.0:8888->8888/tcp
nimbleinfra_zookeeper_1           2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp
```

In case of port binding errors, the shown default port mappings can be adapted to local system requirements in `infra/docker-compose.yml`.

The infrastructure services can be tested by the following http-requests:

  * http://localhost:8888/env => list configuration properties from `nimbleinfra_config-server_1`
  * http://localhost:8761/ => list registered services from Eureka `nimbleinfra_service-discovery_1` (only "gateway-proxy" in the beginning)
  * http://localhost/mappings => list of mappings provided by the `nimbleinfra_gateway-proxy_1`
  * http://localhost:8080, https://localhost:8443 => Administration console for managing identities and access control from `nimbleinfra_keycloak_1`. Login with `admin` and password `nimbleplatform`

### Starting the NIMBLE core services

`./run-dev.sh services`: log output will be shown in the terminal

  * `docker ps` should show additional 15 containers up and running

```
$ docker ps --format 'table {{.Names}}\t{{.Ports}}'
NAMES                                          PORTS
nimbleservices_business-process-service_1      0.0.0.0:8085->8085/tcp
nimbleservices_catalog-service-srdc_1          0.0.0.0:10095->8095/tcp
nimbleservices_trust-service_1                 9096/tcp, 0.0.0.0:9098->9098/tcp
nimbleservices_marmotta_1                      0.0.0.0:8082->8080/tcp
nimbleservices_identity-service_1              0.0.0.0:9096->9096/tcp
nimbleservices_trust-service-db_1              5432/tcp
nimbleservices_identity-service-db_1           0.0.0.0:5433->5432/tcp
nimbleservices_frontend-service_1              0.0.0.0:8081->8080/tcp
nimbleservices_marmotta-db_1                   0.0.0.0:5437->5432/tcp
nimbleservices_sync-db_1                       5432/tcp
nimbleservices_category-db_1                   5432/tcp
nimbleservices_camunda-db_1                    0.0.0.0:5435->5432/tcp
nimbleservices_frontend-service-sidecar_1      0.0.0.0:9097->9097/tcp
nimbleservices_business-process-service-db_1   0.0.0.0:5434->5432/tcp
nimbleservices_ubl-db_1                        0.0.0.0:5436->5432/tcp
...
```

Port mappings can be adapted in `services/docker-compose.yml`.

Once the services are up, they should show up in the EUREKA Service Discovrery:
  * http://localhost:8761/

If they are all up, they can be tested via the NIMBLE frontend at:

  * http://localhost/frontend

## Appendix

### Deployment Diagram

![Deployment Diagram Production](./docs/deployment_diagram_prod.png)

