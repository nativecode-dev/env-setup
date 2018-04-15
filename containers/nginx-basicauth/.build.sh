#!/bin/bash

DOCKER=`which docker`

echo "Building and tagging image..."
$DOCKER build --rm -t nativecode/app-proxy:latest src/

if [ "$1" = "run" ]; then
  $DOCKER run \
    --rm \
    --name app-proxy \
    nativecode/app-proxy:latest \
  ;
fi

if [ "$1" = "push" ]; then
  echo "Pushing image..."
  $DOCKER image push nativecode/app-proxy:latest
fi

echo "DONE"
