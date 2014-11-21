#!/bin/sh
# Shell script to copy rndc key to /rndc, include our zones, and start bind
if [ ! -e /rndc/rndc.key ]; then
  cp /etc/bind/rndc.key /rndc/rndc.key
fi
echo 'include "/etc/bind/zones.rfc1918";' > /etc/bind/named.conf.local
for I in `ls /zones`; do
  echo "zone \"$I\" { type master; file \"/zones/${I}\"; };" >> /etc/bind/named.conf.local
done
chgrp bind /etc/bind/named.conf.local
exec /usr/sbin/named -g -4 -ubind