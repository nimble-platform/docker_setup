FROM jboss/keycloak:3.4.0.Final

USER root
RUN yum install -y xmlstarlet

USER jboss
RUN xmlstarlet ed --inplace \
    -N x="urn:jboss:domain:undertow:3.0" \
    -a "//x:http-listener" \
    -t attr \
    -n 'proxy-address-forwarding' \
    -v 'true' \
    /opt/jboss/keycloak/standalone/configuration/standalone.xml