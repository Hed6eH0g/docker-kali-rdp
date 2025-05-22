#!/bin/bash

set -e
XRDP_PORT=3390

# Install XFCE
echo "Installing XFCE..."
apt-get update && apt-get install -y \
	kali-linux-default \
	kali-desktop-xfce \
	xorg \
	xrdp \
	xorgxrdp && \
rm -rf /var/lib/apt/lists/*

# Configure XRDP to use XFCE
echo "Configuring XRDP to use XFCE..."
echo xfce4-session > ${HOME}/.xsession

# Update the XRDP configuration to use the specified port
sed -i "s/test -x/# test -x/g" /etc/xrdp/startwm.sh
sed -i "s/exec/# exec/g" /etc/xrdp/startwm.sh
echo "startxfce4" >> /etc/xrdp/startwm.sh

echo "Configuring XRDP to listen on port $XRDP_PORT..."
sed -i "s/3389/${XRDP_PORT}/g" /etc/xrdp/xrdp.ini

# Kill process if exists
if [ -e /var/run/xrdp/xrdp.pid ]; then
    rm /var/run/xrdp/xrdp.pid
fi

if [ -e /var/run/xrdp/xrdp-sesman.pid ]; then
    rm /var/run/xrdp/xrdp-sesman.pid
fi

# Restart XRDP service
echo "Restarting XRDP service..."
service xrdp restart
