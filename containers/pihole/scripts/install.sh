#!/bin/bash

RATE_RELOAD=${RATE_RELOAD:-9}
RATE_UPDATE=${RATE_UPDATE:-2}

# Include command exports.
. /etc/pihole-youtube/env.sh

# Setup initial directories and files.
mkdir ${PIHOLE_YOUTUBE} -p
mkdir ${PIHOLE_YOUTUBE_DNSDUMPSTER} -p
touch ${ADS}
touch ${FILTERED}

# Install DNS Dumpster in custom location.
pip install dnsdumpster --target ${PIHOLE_YOUTUBE_DNSDUMPSTER}/

# Install cron job.
truncate -s 0 ${PIHOLE_YOUTUBE}/crontab
echo "*/$RATE_UPDATE * * * * $PIHOLE_YOUTUBE/updater.sh" >> ${PIHOLE_YOUTUBE}/crontab
echo "*/$RATE_RELOAD * * * * $PIHOLE_YOUTUBE/updater.sh reload" >> ${PIHOLE_YOUTUBE}/crontab
crontab -l > ${PIHOLE_YOUTUBE}/crontab.current
crontab ${PIHOLE_YOUTUBE}/crontab
