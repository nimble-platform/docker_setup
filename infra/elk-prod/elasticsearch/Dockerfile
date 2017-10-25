FROM elasticsearch:5.1.1
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>

# install plugins
RUN elasticsearch-plugin install --batch x-pack

# add configuration
ADD config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

# entry point provides by base image
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]