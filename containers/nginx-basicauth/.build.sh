#!/bin/bash

DOCKER=`which docker`

echo "Building and tagging image..."
$DOCKER build --rm -t nativecode/nginx-basicauth:latest src/

if [ "$1" = "run" ]; then
  $DOCKER run \
    --rm \
    --name nginx-basicauth \
    nativecode/nginx-basicauth:latest \
  ;
fi

if [ "$1" = "push" ]; then
  echo "Pushing image..."
  $DOCKER image push nativecode/nginx-basicauth:latest
fi

echo "DONE"
