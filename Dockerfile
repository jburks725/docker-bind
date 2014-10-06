FROM ubuntu:latest
MAINTAINER jburks725@gmail.com

VOLUME /var/cache/bind

# make sure the package repo is up-to-date
RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y bind9

# copy our BIND config files and chgrp them
COPY  named.conf.options  /etc/bind/named.conf.options
COPY  named.conf.local     /etc/bind/named.conf.local
COPY  db.jasonburks.local /etc/bind/db.jasonburks.local
COPY  db.168.192.in-addr.arpa /etc/bind/db.168.192.in-addr.arpa
COPY  zones.rfc1918       /etc/bind/zones.rfc1918
RUN cd /etc/bind && chgrp bind named.conf.*

EXPOSE 53 53/udp

CMD ["/usr/sbin/named", "-g", "-4", "-ubind"]