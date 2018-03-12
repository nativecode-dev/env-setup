#!/bin/bash

# Include command exports.
. /etc/pihole-youtube/env.sh

if [ -f ${PIHOLE_YOUTUBE}/update.lock ]; then
  echo "Lock file detected, skipping."
  exit 0
fi

touch ${PIHOLE_YOUTUBE}/update.lock

# Add youtube ads list to default list.
if [ ! -f ${LIST_OUT} ]; then
  echo "## Local YouTube Ad List" >> ${PIHOLE}/adlists.list
  echo "http://localhost/$LIST_OUT_NAME" >> ${PIHOLE}/adlists.list
  touch ${LIST_OUT}
fi

if [ ! -f /var/www/html/${LIST_OUT_NAME} ]; then
  ln -s ${LIST_OUT} /var/www/html/${LIST_OUT_NAME}
fi

if [ -f ${PIHOLE}/youtube ]; then
  rm -rf ${PIHOLE}/youtube
fi

if [ -f ${PIHOLE}/youtube-ads.sh ]; then
  rm ${PIHOLE}/youtube-ads.sh
fi

if [ -f ${PIHOLE}/youtube-install.sh ]; then
  rm ${PIHOLE}/youtube-install.sh
fi

TIMESTAMP_FILE=${LIST_OUT_NAME}.`date +%s%N | cut -b1-13`
LIST_TIMESTAMP=/tmp/${TIMESTAMP_FILE}

# Copy the current list to updates for inclusion.
cat ${LIST_OUT} > ${LIST_OUT}.updates

# Truncate all dns dumpster output.
truncate -s 0 ${ADS}
truncate -s 0 ${DOMAINS}
truncate -s 0 ${FILTERED}

# Update DNS information, if possible.
python ${YOUTUBE_SCRIPT} >> ${DOMAINS}
grep ^r ${DOMAINS} >> ${FILTERED}
sed 's/\s.*$//' ${FILTERED} >> ${ADS}
cat ${ADS} | uniq >> ${LIST_OUT}.updates

# Search for blockable sites from logs.
grep r*.googlevideo.com ${PIHOLE_LOGS} | awk '{print $8}' | grep -v '^googlevideo.com\|redirector' | sort -nr | uniq >> ${LIST_OUT}.updates

# Re-select everything and only return a unique list.
cat ${LIST_OUT} > ${LIST_TIMESTAMP}
cat ${LIST_OUT}.updates | sort -n | uniq > ${LIST_OUT}
cat ${LIST_OUT} | wc -l > ${LIST_OUT}.count
rm ${LIST_OUT}.updates

# Removes duplicate entries.
perl -i -ne 'print if ! $x{$_}++' ${LIST_OUT}

# Shrink timestamp file and remove zero-byte files.
find /tmp/${LIST_OUT_NAME}.* -size  0 -print0 | xargs -0 rm
if [ -f ${LIST_TIMESTAMP} ]; then
  tar -czvf ${LIST_TIMESTAMP}.tar.gz ${LIST_TIMESTAMP}
  rm ${LIST_TIMESTAMP}
fi

# Release lock.
rm ${PIHOLE_YOUTUBE}/update.lock
