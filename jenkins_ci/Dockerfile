FROM jenkins/jenkins:lts
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>
USER root

#RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common maven
#RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
#RUN apt-key fingerprint 0EBFCD88

#RUN add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"

#RUN apt-get update && apt-get install -y docker-ce && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y maven wget nodejs && rm -rf /var/lib/apt/lists/*

#Installing Docker
ENV DOCKER_VERSION 17.06.0-ce
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz &&\
	tar -xvf docker-${DOCKER_VERSION}.tgz &&\
	cp docker/docker* /usr/bin/ &&\
	chown jenkins:jenkins /usr/bin/docker*
