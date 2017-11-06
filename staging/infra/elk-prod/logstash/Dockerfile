FROM docker.elastic.co/logstash/logstash:5.6.3
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>

# adding configuration
ADD config/logstash.conf /etc/logstash/conf.d/logstash.conf

#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["--log.level", "debug", "--verbose", "--config.debug", "-f", "/etc/logstash/conf.d/logstash.conf"]