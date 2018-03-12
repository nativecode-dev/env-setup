#!/bin/bash

# Include command exports.
. /etc/pihole-youtube/env.sh

if [ -f ${PIHOLE_YOUTUBE}/update.lock ]; then
  echo "Lock file detected, skipping."
  exit 0
fi

# Create lock reservation.
touch ${PIHOLE_YOUTUBE}/update.lock

# Add youtube ads list to default list.
if [ ! -f ${PIHOLE_YOUTUBE_LIST} ]; then
  echo "## Local YouTube Ad List" >> ${PIHOLE}/adlists.list
  echo "http://localhost/$PIHOLE_YOUTUBE_LIST_NAME" >> ${PIHOLE}/adlists.list
  touch ${PIHOLE_YOUTUBE_LIST}
fi

if [ ! -f /var/www/html/${PIHOLE_YOUTUBE_LIST_NAME} ]; then
  ln -s ${PIHOLE_YOUTUBE_LIST} /var/www/html/${PIHOLE_YOUTUBE_LIST_NAME}
fi

TIMESTAMP_FILE=${PIHOLE_YOUTUBE_LIST_NAME}.`date +%s%N | cut -b1-13`
LIST_TIMESTAMP=/tmp/${TIMESTAMP_FILE}

# Copy the current list to updates for inclusion.
curl -s "https://api.hackertarget.com/hostsearch/?q=googlevideo.com" | awk -F, 'NR>1 {print $1}' > ${PIHOLE_YOUTUBE_LIST}.updates
cat ${PIHOLE_YOUTUBE_LIST} >> ${PIHOLE_YOUTUBE_LIST}.updates

# Search for blockable sites from logs.
grep r*.googlevideo.com ${PIHOLE_LOGS} | awk '{print $8}' | grep -v '^googlevideo.com\|redirector' >> ${PIHOLE_YOUTUBE_LIST}.updates

# Re-select everything and only return a unique list.
cat ${PIHOLE_YOUTUBE_LIST} > ${LIST_TIMESTAMP}
cat ${PIHOLE_YOUTUBE_LIST}.updates | sort -n | uniq > ${PIHOLE_YOUTUBE_LIST}
cat ${PIHOLE_YOUTUBE_LIST} | wc -l > ${PIHOLE_YOUTUBE_LIST}.count
rm ${PIHOLE_YOUTUBE_LIST}.updates

# Removes duplicate entries.
perl -i -ne 'print if ! $x{$_}++' ${PIHOLE_YOUTUBE_LIST}

# Shrink timestamp file and remove zero-byte files.
find /tmp/${PIHOLE_YOUTUBE_LIST_NAME}.* -size  0 -print0 | xargs -0 rm
if [ -f ${LIST_TIMESTAMP} ]; then
  tar -czvf ${LIST_TIMESTAMP}.tar.gz ${LIST_TIMESTAMP}
  rm ${LIST_TIMESTAMP}
fi

# Flush pi-hole logs.
$PIHOLE_CLI -f

# Release lock.
rm ${PIHOLE_YOUTUBE}/update.lock
