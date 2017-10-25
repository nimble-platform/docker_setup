FROM logstash:5.1.1
MAINTAINER Salzburg Research <nimble-srfg@salzburgresearch.at>

ADD config/logstash.conf /etc/logstash/conf.d/logstash.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["--log.level", "debug", "--verbose", "--config.debug", "-f", "/etc/logstash/conf.d/logstash.conf"]