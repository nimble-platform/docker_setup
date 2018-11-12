FROM jboss/keycloak:4.3.0.Final

USER jboss
COPY ./themes/ $JBOSS_HOME/themes/

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]