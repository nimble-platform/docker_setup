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
	* ** Configuration**: `prod/keycloak/docker-compose-prod.yml`
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
	* 
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

## Development Deployment

* Location: `dev`

not yet active

## Appendix

### Deployment Diagram

![Deployment Diagram Production](./docs/deployment_diagram_prod.png)

