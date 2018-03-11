#!/bin/bash

DOCKER=`which docker`

$DOCKER build --rm -t nativecode/pihole:latest pihole/

$DOCKER run --rm \
  --name pihole \
  -e ServerIP="127.0.0.1" \
  -v PIHOLE:/etc/pihole \
  -v PIHOLEDNS:/etc/dnsmasq.d \
  nativecode/pihole:latest \
;

$DOCKER image push nativecode/pihole:latest
