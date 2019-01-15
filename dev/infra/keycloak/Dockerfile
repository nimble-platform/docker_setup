FROM jboss/keycloak:3.4.3.Final

USER jboss
COPY ./themes/ $JBOSS_HOME/themes/

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]