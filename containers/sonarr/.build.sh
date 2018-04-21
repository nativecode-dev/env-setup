#!/bin/bash

DOCKER=`which docker`

echo "Building and tagging image..."
$DOCKER build --rm -t docker.nativecode.net/sonarr:latest .

if [ "$1" = "run" ]; then
  $DOCKER run \
    --rm \
    --name sonarr \
    docker.nativecode.net/sonarr:latest \
  ;
fi

if [ "$1" = "push" ]; then
  echo "Pushing image..."
  $DOCKER image push docker.nativecode.net/sonarr:latest
fi

echo "DONE"
