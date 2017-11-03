#!/usr/bin/env bash

docker build -t nimbleplatform/jenkins-master:latest .
docker push nimbleplatform/jenkins-master:latest