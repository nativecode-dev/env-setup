#!/bin/bash

# Include common exports.
. /etc/pihole-youtube/env.sh

if [ -f ${PIHOLE_YOUTUBE}/update.lock ]; then
  echo "Lock file detected, skipping."
  exit 0
fi

# Create lock reservation.
echo "Creating lock file"
touch ${PIHOLE_YOUTUBE}/update.lock

TIMESTAMP_FILE=${PIHOLE_YOUTUBE_LIST_NAME}.`date +%s%N | cut -b1-13`
TIMESTAMP_FILE_LIST=/tmp/${TIMESTAMP_FILE}

# Add youtube ads list to default list.
if [ ! -f ${PIHOLE_YOUTUBE_LIST} ]; then
  echo "##Local YouTube Ad List" >> ${PIHOLE}/adlists.list
  echo "http://localhost/$PIHOLE_YOUTUBE_LIST_NAME" >> ${PIHOLE}/adlists.list
  touch ${PIHOLE_YOUTUBE_LIST}
fi

if [ ! -f /var/www/html/${PIHOLE_YOUTUBE_LIST_NAME} ]; then
  echo "Creating symlink to ad list"
  ln -s ${PIHOLE_YOUTUBE_LIST} /var/www/html/${PIHOLE_YOUTUBE_LIST_NAME}
fi

# Create a backup before we do anything else.
if [ "$1" = "backup" ]; then
  echo "Creating backup file archive from $PIHOLE_YOUTUBE_LIST..."
  mkdir ${PIHOLE_YOUTUBE_BACKUPS} -p
  cd ${PIHOLE}
  # Stupid tar, have to be in or below the directory we want, can't be a sibling.
  tar -czvf ${PIHOLE_YOUTUBE_BACKUPS}/${TIMESTAMP_FILE}.tgz ${PIHOLE_YOUTUBE_LIST_NAME} > /dev/null
  cd ${PIHOLE_YOUTUBE}
fi

# Copy the current list to updates for inclusion.
echo "Creating updates file..."
curl -s "https://api.hackertarget.com/hostsearch/?q=googlevideo.com" | grep r*.googlevideo.com | awk -F, 'NR>1 {print $1}' > ${PIHOLE_YOUTUBE_LIST_UPDATE}
cat ${PIHOLE_YOUTUBE_LIST} >> ${PIHOLE_YOUTUBE_LIST_UPDATE}

# Search for blockable sites from logs.
grep r*.googlevideo.com ${PIHOLE_LOGS} | awk '{print $8}' | grep -v '^googlevideo.com' >> ${PIHOLE_YOUTUBE_LIST_UPDATE}

# Re-select everything and only return a unique list.
cat ${PIHOLE_YOUTUBE_LIST} > ${TIMESTAMP_FILE_LIST}
cat ${PIHOLE_YOUTUBE_LIST_UPDATE} | sort -n | uniq > ${PIHOLE_YOUTUBE_LIST}
cat ${PIHOLE_YOUTUBE_LIST} | wc -l > ${PIHOLE_YOUTUBE_LIST}.count

if [ -f ${PIHOLE_YOUTUBE_LIST_UPDATE} ]; then
  echo "Removing updates file..."
  rm ${PIHOLE_YOUTUBE_LIST_UPDATE}
fi

# Shrink timestamp file and remove zero-byte files.
find /tmp/${PIHOLE_YOUTUBE_LIST_NAME}.* -size  0 -print0 | xargs -0 rm -f

if [ -f ${TIMESTAMP_FILE_LIST} ]; then
  rm ${TIMESTAMP_FILE_LIST}
fi

# Flush pi-hole logs.
$PIHOLE_CLI -f

# Release lock.
echo "Releasing lock file"
rm ${PIHOLE_YOUTUBE}/update.lock
