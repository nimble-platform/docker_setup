# Deployment Setup

The setup is split into to three configuration scenarios, whereas each scenario has a dedicated directory with the same name. The directory structure is as follows:

* `jenkins_ci`: setup for Jenkins CI
* `nginx`: setup and configuration for the webserver (i.e. nginx)
* `dev`: deployment setup for local development
* `staging`: 	deployment setup for staging environment
* `prod`: deployment setup used in production

Each deployment setup is composed of infrastructure componententes and the actual Microservices. A utility script with the name `run*.sh` can be found in the directories of each setup.