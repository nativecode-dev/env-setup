#!/bin/bash

# Root locations.
export PIHOLE=/etc/pihole
export PIHOLE_YOUTUBE=${PIHOLE}-youtube
export PIHOLE_YOUTUBE_DNSDUMPSTER=${PIHOLE_YOUTUBE}/dnsdumpster
export PIHOLE_HTML=/var/www/html
export PIHOLE_LOGS=/var/log/pihole.log

# Generated files.
export ADS=${PIHOLE_YOUTUBE_DNSDUMPSTER}/youtube-ads.txt
export DOMAINS=${PIHOLE_YOUTUBE_DNSDUMPSTER}/youtube-domains.txt
export FILTERED=${PIHOLE_YOUTUBE_DNSDUMPSTER}/youtube-filtered.txt

export LIST_OUT_NAME=youtube.list
export LIST_OUT=${PIHOLE}/${LIST_OUT_NAME}

# Scripts.
export YOUTUBE_SCRIPT=${PIHOLE_YOUTUBE}/dnsdumpster/youtube.py
