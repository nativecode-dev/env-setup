#!/bin/bash

CONTAINER_DIR=/var/lib/docker/containers
CONTAINER_ID=`docker inspect --format="{{.Id}}" rancher-agent`
CONTAINER_PATH=$CONTAINER_DIR/$CONTAINER_ID
CONTAINER_CONFIG=$CONTAINER_PATH/config.v2.json

echo "Use rancher-update [update|restore]"
echo "$1"

if [ "$1" == "update" ]; then
  if [ -f $CONTAINER_CONFIG ]; then
    echo "Updating container $CONTAINER_ID..."
    cp $CONTAINER_CONFIG $CONTAINER_CONFIG.bak
    systemctl stop docker
    sed -i 's/CATTLE_AGENT_IP/CATTLE_AGENT_IP='"$COREOS_PRIVATE_IPV4"'/g' $CONTAINER_CONFIG
    systemctl start docker
  fi

  exit 0
fi

if [ "$1" == "restore" ]; then
  if [ -f $CONTAINER_CONFIG ]; then
    echo "Restoring $CONTAINER_CONFIG..."
    cp $CONTAINER_CONFIG $CONTAINER_CONFIG.bak
    systemctl stop docker
    sed -i 's/CATTLE_AGENT_IP='"$COREOS_PRIVATE_IPV4"'/CATTLE_AGENT_IP/g' $CONTAINER_CONFIG
    systemctl start docker
  fi

  exit 0
fi

