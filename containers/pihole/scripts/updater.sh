#!/bin/bash

# CWD: /etc/pihole
# Include common exports.
. /etc/pihole-youtube/env.sh

cd ${PIHOLE}

URL_HACKERTARGET="https://api.hackertarget.com/hostsearch/?q=googlevideo.com"
URL_YOUTUBE_GIST="https://cdn.rawgit.com/mikepham/cb0d9ecdc1709705f8f80f4903d6aeef/raw/youtube.list"

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

# SOURCE: current
echo "[source] youtube.list"
cat ${PIHOLE_YOUTUBE_LIST} \
  > ${PIHOLE_YOUTUBE_LIST_UPDATE}

# SOURCE: hackertarget
echo "[source] $URL_HACKERTARGET"
curl -s ${URL_HACKERTARGET} \
  | awk -F, 'NR>1 {print $1}' \
  >> ${PIHOLE_YOUTUBE_LIST_UPDATE}

# SOURCE: gist
echo "[source] $URL_YOUTUBE_GIST"
curl -s ${URL_YOUTUBE_GIST} \
  >> ${PIHOLE_YOUTUBE_LIST_UPDATE}

# SOURCE: pihole.log
echo "[source] $PIHOLE_LOGS"
cat ${PIHOLE_LOGS} \
  | awk '{print $8}' \
  | grep -v redirector.googlevideo.com \
  >> ${PIHOLE_YOUTUBE_LIST_UPDATE}

# Re-select everything and only return a unique list.
echo "Updating $PIHOLE_YOUTUBE_LIST"
cat ${PIHOLE_YOUTUBE_LIST_UPDATE} \
  | grep -E 'r[0-9]+.*.googlevideo.com' \
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
