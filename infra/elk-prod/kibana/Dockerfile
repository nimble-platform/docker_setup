FROM kibana:5.1.1
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>

# install plugins
RUN kibana-plugin install x-pack

# copy config
COPY config/kibana.yml /opt/kibana/config/

# handle entry point
COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

CMD ["/tmp/entrypoint.sh"]
