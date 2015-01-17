FROM debian:latest
MAINTAINER Jason Burks <jburks725@gmail.com>

# Quiet apt down a bit
ENV DEBIAN_FRONTEND noninteractive

VOLUME /zones

# make sure the package repo is up-to-date
RUN apt-get update && \
    apt-get install -y bind9

# copy our BIND config files and chgrp them
COPY  named.conf.options  /etc/bind/named.conf.options
COPY  zones/              /zones/
COPY  zones.rfc1918       /etc/bind/zones.rfc1918
COPY  start-bind.sh       /start-bind.sh
RUN chgrp bind /etc/bind/named.conf.* && \
    chmod -R o+r /zones

EXPOSE 53 53/udp

CMD ["/start-bind.sh"]

# Clean up APT when done.
RUN apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
