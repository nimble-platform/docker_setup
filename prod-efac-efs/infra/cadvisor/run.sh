#!/bin/bash

set -ev

curdir=$(dirname "$0")

docker-compose -f docker-compose.yml --project-name efactoryefsinfra up --build -d

#write out current crontab
mkdir -p cron_logs
crontab -l > mycron

#echo new cron into cron file
echo "0 0 * * * /bin/bash $(realpath $curdir)/update-cadvisor.sh >> $(realpath $curdir)/cron_logs/log.txt 2>&1"

#install new cron file
crontab mycron
rm mycron
