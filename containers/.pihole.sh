#!/bin/bash

DOCKER=`which docker`

echo "Building and tagging image..."
$DOCKER build --rm -t nativecode/pihole:latest containers/pihole/

if [ "$1" = "run" ]; then
  $DOCKER run \
    --rm \
    --name pihole \
    -d \
    -e ServerIP="127.0.0.1" \
    -e RATE_RELOAD="2" \
    -e RATE_UPDATE="2" \
    -v PIHOLE:/etc/pihole \
    -v PIHOLEDNS:/etc/dnsmasq.d \
    nativecode/pihole:latest \
  ;

  $DOCKER exec -it pihole /bin/bash

  echo "Cleaning up container and volumes..."
  $DOCKER stop pihole
  $DOCKER volume rm PIHOLE
  $DOCKER volume rm PIHOLEDNS
fi

if [ "$1" = "push" ]; then
  echo "Pushing image..."
  $DOCKER image push nativecode/pihole:latest
fi

echo "DONE"