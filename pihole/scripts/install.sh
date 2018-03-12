#!/bin/bash

# Include command exports.
. /etc/pihole-youtube/env.sh

# Setup initial directories and files.
mkdir ${PIHOLE_YOUTUBE} -p
mkdir ${PIHOLE_YOUTUBE_DNSDUMPSTER} -p
touch ${ADS}
touch ${FILTERED}
touch ${LIST_OUT}

# Install DNS Dumpster in custom location.
pip install dnsdumpster --target ${PIHOLE_YOUTUBE_DNSDUMPSTER}/

# Run the script for the first time.
sh ${PIHOLE_YOUTUBE}/updater.sh

# Add youtube ads list to default list.
if [ -f ${LIST_OUT} ]; then
  echo "http://localhost/$LIST_OUT_NAME" >> ${PIHOLE}/adlists.list
fi

# Install cron job.
echo "*/15 * * * * $PIHOLE_YOUTUBE/updater.sh reload" > ${PIHOLE_YOUTUBE}/crontab
crontab -l > ${PIHOLE_YOUTUBE}/crontab.current
crontab ${PIHOLE_YOUTUBE}/crontab
