#!/bin/bash

# CWD: /etc/pihole
# Include common exports.
. /etc/pihole-youtube/env.sh

URL="https://api.hackertarget.com/hostsearch/?q=googlevideo.com"

if [ -f ${PIHOLE_YOUTUBE}/update.lock ]; then
  echo "Lock file detected, skipping."
  exit 0
fi

# Create lock reservation.
echo "Creating lock file"
touch ${PIHOLE_YOUTUBE}/update.lock

# If the youtube list doesn't exist and add to pi-hole list.
if [ ! -f ${PIHOLE_YOUTUBE_LIST} ]; then
  echo "##Local YouTube Ad List" >> ${PIHOLE}/adlists.list
  echo "http://localhost/$PIHOLE_YOUTUBE_LIST_NAME" >> ${PIHOLE}/adlists.list
  touch ${PIHOLE_YOUTUBE_LIST}
fi

# Create symlink if it doesn't exist.
if [ ! -f /var/www/html/${PIHOLE_YOUTUBE_LIST_NAME} ]; then
  echo "Creating symlink to ad list"
  ln -s ${PIHOLE_YOUTUBE_LIST} /var/www/html/${PIHOLE_YOUTUBE_LIST_NAME}
fi

# Append current list to a backup.list file.
if [ ! -f ${PIHOLE_BACKUP_LIST} ]; then
  echo "Creating backup file: $PIHOLE_BACKUP_LIST"
  cat ${PIHOLE_YOUTUBE_LIST} > ${PIHOLE_BACKUP_LIST}
else
  echo "Appending backup file: $PIHOLE_BACKUP_LIST"
  echo "##[ARCHIVED:$TIMESTAMP]" >> ${PIHOLE_BACKUP_LIST}
  cat ${PIHOLE_YOUTUBE_LIST} >> ${PIHOLE_BACKUP_LIST}
fi

# Create a backup before we do anything else.
if [ "$1" = "backup" ]; then
  echo "Archiving file $PIHOLE_BACKUP_LIST..."
  if [ ! -f ${PIHOLE_YOUTUBE_BACKUPS} ]; then
    mkdir ${PIHOLE_YOUTUBE_BACKUPS} -p
  fi

  tar -czvf ${PIHOLE_YOUTUBE_BACKUPS}/${TIMESTAMP_FILE}.tgz ${PIHOLE_BACKUP_LIST_NAME}
  rm ${PIHOLE_BACKUP_LIST}
fi

# Grab the known domains from hackertarget.com.
echo "Creating updates file..."
curl -s ${URL} | awk -F, 'NR>1 {print $1}' > ${PIHOLE_YOUTUBE_LIST_UPDATE}
cat ${PIHOLE_YOUTUBE_LIST} >> ${PIHOLE_YOUTUBE_LIST_UPDATE}

# Search for blockable sites from logs.
cat ${PIHOLE_LOGS} | awk '{print $8}' >> ${PIHOLE_YOUTUBE_LIST_UPDATE}

# Re-select everything and only return a unique list.
cat ${PIHOLE_YOUTUBE_LIST_UPDATE} \
  | grep r*.googlevideo.com \
  | grep -v "redirector.googlevideo.com" \
  | sort -n \
  | uniq \
  > ${PIHOLE_YOUTUBE_LIST}

# Cleanup the update files.
if [ -f ${PIHOLE_YOUTUBE_LIST_UPDATE} ]; then
  echo "Removing updates file..."
  rm ${PIHOLE_YOUTUBE_LIST_UPDATE}
fi

# Flush pi-hole logs.
$PIHOLE_CLI -f

# Release lock.
echo "Releasing lock file"
rm ${PIHOLE_YOUTUBE}/update.lock
