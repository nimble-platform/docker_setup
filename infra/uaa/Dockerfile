FROM java:openjdk-8u66-jre
MAINTAINER nimble-srfg@salzburgresearch.at

ENV UAA_CONFIG_PATH /uaa
ENV CATALINA_HOME /tomcat

ADD entrypoint.sh /tmp/
ADD dev.yml /uaa/uaa.yml
RUN chmod +x /tmp/entrypoint.sh

# install tomcat
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz
RUN wget -qO- https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz.md5 | md5sum -c -

RUN tar zxf apache-tomcat-8.0.28.tar.gz
RUN rm apache-tomcat-8.0.28.tar.gz

RUN mkdir /tomcat
RUN mv apache-tomcat-8.0.28/* /tomcat
RUN rm -rf /tomcat/webapps/*

# download Cloud Foundry UAA
RUN wget http://central.maven.org/maven2/org/cloudfoundry/identity/cloudfoundry-identity-uaa/3.8.0/cloudfoundry-identity-uaa-3.8.0.war
RUN mv cloudfoundry-identity-uaa-3.8.0.war /tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["/tmp/entrypoint.sh"]
