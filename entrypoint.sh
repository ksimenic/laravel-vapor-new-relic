#! /bin/sh

# start New Relic daemon
newrelic-daemon -c /usr/local/etc/newrelic/newrelic.cfg

# start PHP
/opt/bootstrap

newrelic_background_job(false);
