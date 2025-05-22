#!/bin/bash

set -e

if [ -f /var/run/xrdp/xrdp.pid ]; then
    rm /var/run/xrdp/xrdp.pid 
fi
if [ -f /var/run/xrdp/xrdp-sesman.pid ]; then
    rm /var/run/xrdp/xrdp-sesman.pid 
fi
/etc/init.d/xrdp start
rm /home/${NONROOT_USER}/entrypoint.sh

export -n ${ROOT_PASSWD}
export -n ${NONROOT_USER}
export -n ${NONROOT_PASSWD}

sleep infinity
