ARG VERSION

FROM laravelphp/vapor:${VERSION}

ARG NEW_RELIC_VERSION
ARG NEW_RELIC_APP_NAME
ARG NEW_RELIC_LICENSE

# Download and install New Relic: https://download.newrelic.com/php_agent/release/
RUN \
    curl -L "https://download.newrelic.com/php_agent/archive/${NEW_RELIC_VERSION}/newrelic-php5-${NEW_RELIC_VERSION}-linux-musl.tar.gz" | tar -C /tmp -zx && \
    export NR_INSTALL_USE_CP_NOT_LN=1 && \
    export NR_INSTALL_SILENT=1 && \
    /tmp/newrelic-php5-*/newrelic-install install

# add global var to php.ini file
RUN echo "" >> /usr/local/etc/php/php.ini
RUN echo "extension = \"newrelic.so\"" >> /usr/local/etc/php/php.ini
RUN echo "newrelic.logfile = \"/dev/null\"" >> /usr/local/etc/php/php.ini
RUN echo "newrelic.loglevel = \"error\"" >> /usr/local/etc/php/php.ini
RUN echo "newrelic.appname = \"${NEW_RELIC_APP_NAME}\"" >> /usr/local/etc/php/php.ini
RUN echo "newrelic.license = \"${NEW_RELIC_LICENSE}\"" >> /usr/local/etc/php/php.ini

# Remove newrelic.ini file
RUN rm /usr/local/etc/php/conf.d/newrelic.ini

# Configure proxy daemon https://docs.newrelic.com/docs/apm/agents/php-agent/configuration/proxy-daemon-newreliccfg-settings/
RUN mkdir -p /usr/local/etc/newrelic && \
  echo "loglevel=error" > /usr/local/etc/newrelic/newrelic.cfg && \
  echo "logfile=/dev/null" >> /usr/local/etc/newrelic/newrelic.cfg

COPY . /var/task

USER root
RUN chmod +x /var/task/entrypoint.sh
ENTRYPOINT ["/var/task/entrypoint.sh"]
