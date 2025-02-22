#!/bin/bash

KBLAYOUT=$1
ROOTPW=$2

if [ ! -e '/check' ]; then
    touch /check
    setxkbmap ${KBLAYOUT}
    usermod --password $(echo $ROOTPW | openssl passwd -1 -stdin) root
fi

if [ -f /var/run/xrdp/xrdp.pid ]; then
    rm /var/run/xrdp/xrdp.pid 
fi
if [ -f /var/run/xrdp/xrdp-sesman.pid ]; then
    rm /var/run/xrdp/xrdp-sesman.pid 
fi
/etc/init.d/xrdp start
