#!/bin/bash

CONTAINER_DIR=/var/lib/docker/containers
CONTAINER_ID=`docker inspect --format="{{.Id}}" rancher-agent`
CONTAINER_PATH=$CONTAINER_DIR/$CONTAINER_ID
CONTAINER_CONFIG=$CONTAINER_PATH/config.v2.json

if [ $1 == "update" ]; then

    if [ -f $CONTAINER_CONFIG ]; then

    cp $CONTAINER_CONFIG $CONTAINER_CONFIG.bak

    systemctl stop docker

    sed -i 's/CATTLE_AGENT_IP/CATTLE_AGENT_IP='"$COREOS_PRIVATE_IPV4"'/g' $CONTAINER_CONFIG

    systemctl start docker

  fi

fi

if [ $1 == "restore" ]; then

  if [ -f $CONTAINER_CONFIG ]; then

    cp $CONTAINER_CONFIG $CONTAINER_CONFIG.bak

    systemctl stop docker

    sed -i 's/CATTLE_AGENT_IP='"$COREOS_PRIVATE_IPV4"'/CATTLE_AGENT_IP/g' $CONTAINER_CONFIG

    systemctl start docker

  fi

fi

