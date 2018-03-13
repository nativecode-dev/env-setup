#!/bin/bash

# CWD: /etc/pihole-youtube
# Include common exports.
. /etc/pihole-youtube/env.sh

# Define pi-hole youtube specific rates.
PIHOLE_BACKUP_RATE=${RATE_BACKUP:-59}
PIHOLE_RELOAD_RATE=${RATE_RELOAD:-5}
PIHOLE_UPDATE_RATE=${RATE_UPDATE:-2}

# Install cron job.
truncate -s 0 ${PIHOLE_YOUTUBE}/crontab
echo "*/$PIHOLE_BACKUP_RATE * * * * $PIHOLE_YOUTUBE/updater.sh backup" >> ${PIHOLE_YOUTUBE}/crontab
echo "*/$PIHOLE_RELOAD_RATE * * * * $PIHOLE_CLI -g" >> ${PIHOLE_YOUTUBE}/crontab
echo "*/$PIHOLE_UPDATE_RATE * * * * $PIHOLE_YOUTUBE/updater.sh" >> ${PIHOLE_YOUTUBE}/crontab
crontab -l > ${PIHOLE_YOUTUBE}/crontab.current
crontab ${PIHOLE_YOUTUBE}/crontab
