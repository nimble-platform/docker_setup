#!/usr/bin/env bash

# set proper context path
if [[ -v CONTEXT_PATH ]]; then
    echo "Setting web context path to ${CONTEXT_PATH}"
    sed -i -e "s/<web-context>auth<\/web-context>/<web-context>${CONTEXT_PATH:auth}<\/web-context>/" ${JBOSS_HOME}/standalone/configuration/standalone.xml
fi

# disabling cache
if [[ -v THEME_DEV ]]; then
    echo "Disabling cache for theme development"
    sed -i -e "s/<staticMaxAge>.*<\/staticMaxAge>/<staticMaxAge>-1<\/staticMaxAge>/" ${JBOSS_HOME}/standalone/configuration/standalone.xml
    sed -i -e "s/<cacheThemes>.*<\/cacheThemes>/<cacheThemes>false<\/cacheThemes>/" ${JBOSS_HOME}/standalone/configuration/standalone.xml
    sed -i -e "s/<cacheTemplates>.*<\/cacheTemplates>/<cacheTemplates>false<\/cacheTemplates>/" ${JBOSS_HOME}/standalone/configuration/standalone.xml
fi

# execute original entrypoint
exec /opt/jboss/docker-entrypoint.sh $@
exit $?