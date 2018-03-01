#!/bin/bash

SVC_NAME=openvpn-server.service
SYSINIT=/etc/systemd/system/$SVC_NAME

if [ ! -f $SYSINIT ]; then

  OVPN_DATA="ovpn-data-nativecode-production"

cat <<EOT >> $SYSINIT
[Unit]
Description=OpenVPN Server
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/bin/docker run \
  --name openvpn-server \
  --hostname vpn-admin \
  --rm \
  --cap-add=NET_ADMIN \
  -p 1194:1194/udp \
  -v $OVPN_DATA:/etc/openvpn \
  kylemanna/openvpn \
;
ExecStop=/usr/bin/docker stop openvpn-server
TimeoutSec=600

[Install]
WantedBy=multi-user.target
EOT

  docker volume create --name $OVPN_DATA
  docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://vpn-admin.nativecode.com
  docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
  docker run -v $OVPN_DATA:/etc/openvpn -d --name setup-openvpn -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
  docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full nativecode-production nopass
  docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient nativecode-production > nativecode-production.ovpn
  docker stop setup-openvpn
  docker rm setup-openvpn
  systemctl enable --now $SYSINIT

fi
