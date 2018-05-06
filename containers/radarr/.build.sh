#!/bin/bash

DOCKER=`which docker`

echo "Building and tagging image..."
$DOCKER build --rm -t docker.nativecode.net/radarr:latest .

if [ "$1" = "run" ]; then
  $DOCKER run \
    --rm \
    --name radarr \
    docker.nativecode.net/radarr:latest \
  ;
fi

if [ "$1" = "push" ]; then
  echo "Pushing image..."
  $DOCKER image push docker.nativecode.net/radarr:latest

  $DOCKER build --rm -t nativecode/radarr:latest .
  $DOCKER image push nativecode/radarr:latest
fi

echo "DONE"
