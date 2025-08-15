#!/bin/bash

set -e

rm -f /var/run/xrdp/xrdp.pid /var/run/xrdp/xrdp-sesman.pid
/usr/sbin/xrdp-sesman && /etc/init.d/xrdp start

mkdir -p /dev/net
if [ ! -e /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

if [ $# -eq 0 ]; then
    sleep infinity
else
    exec "$@"
fi
