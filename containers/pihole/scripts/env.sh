#!/bin/bash

export PIHOLE_CLI=`which pihole`

# Root locations.
export PIHOLE=/etc/pihole
export PIHOLE_YOUTUBE=${PIHOLE}-youtube
export PIHOLE_YOUTUBE_BACKUPS=${PIHOLE}/backups
export PIHOLE_HTML=/var/www/html
export PIHOLE_LOGS=/var/log/pihole.log

# File locations.
export PIHOLE_YOUTUBE_LIST_NAME=youtube.list
export PIHOLE_YOUTUBE_LIST_UPDATE=/tmp/${PIHOLE_YOUTUBE_LIST_NAME}.update
export PIHOLE_YOUTUBE_LIST=${PIHOLE}/${PIHOLE_YOUTUBE_LIST_NAME}
export PIHOLE_YOUTUBE_LIST_UPDATE=/tmp/${PIHOLE_YOUTUBE_LIST_NAME}.update
