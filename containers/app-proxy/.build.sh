#!/bin/bash

DOCKER=`which docker`

echo "Building and tagging image..."
$DOCKER build --rm -t docker.nativecode.net/app-proxy:latest .

if [ "$1" = "run" ]; then
  $DOCKER run \
    --rm \
    --name app-proxy \
    docker.nativecode.net/app-proxy:latest \
  ;
fi

if [ "$1" = "push" ]; then
  echo "Pushing image..."
  $DOCKER image push docker.nativecode.net/app-proxy:latest
fi

echo "DONE"
