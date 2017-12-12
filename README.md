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

* TODO: Describe NGINX
* TODO: Describe JENKINS

## Productive Deployment

* Location: `prod`

In general the Platform is split into two different kind of components (1) infrastructure components (directory `infra`) and (2) microservice components (directory `services`).

### Infrastructure Components

These componentes are part of the virtual network with the name `nimbleinfraprod_default`. More information can be found bey executing `docker network inspect nimbleinfraprod_default` on the Docker host.

#### General Infrastructure

* Marmotta
	* **Setup**: `prod/infra/docker-compose-marmotta.yml`
	* **Container Name**: nimbleinfraprod\_marmotta\_1 
* Keycloak
	* **Setup**: `prod/keycloak/docker-compose-prod.yml`
	* **Container Name**: nimbleinfraprod\_keycloak\_1 
* ELK Stack
	* **Setup**: `prod/elk-prod/docker-compose-elk.yml`
	* **Container Names**: nimbleinfraprod\_kibana\_1, nimbleinfraprod\_elasticsearch\_1, nimbleinfraprod\_logstash\_1

#### Microservice Infrastructure

Defintion can be found in `prod/docker-compose-prod.yml`, which consists of the following components:

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

### Utility Script

A small utility script can be found in `run-prod.sh`, which provides the following functionalies:

* `run-prod.sh infra`: starts all infrastructure components 

### Deployment Diagram

![Deployment Diagram Production](./docs/deployment_diagram_prod.png)

