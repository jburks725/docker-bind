#!/bin/sh
# Shell script to include our zones, if any, and start bind
echo 'include "/etc/bind/zones.rfc1918";' > /etc/bind/named.conf.local
for I in `ls /zones`; do
  echo "zone \"$I\" { type master; file \"/zones/${I}\"; };" >> /etc/bind/named.conf.local
done
chgrp bind /etc/bind/named.conf.local
exec /usr/sbin/named -g -4 -ubind
