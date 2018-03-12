#!/bin/bash

# Include command exports.
. /etc/pihole-youtube/env.sh

if [ -f ${PIHOLE}/youtube ]; then
  rm -rf ${PIHOLE}/youtube
fi

if [ -f ${PIHOLE}/youtube-ads.sh ]; then
  rm ${PIHOLE}/youtube-ads.sh
fi

if [ -f ${PIHOLE}/youtube-install.sh ]; then
  rm ${PIHOLE}/youtube-install.sh
fi

truncate -s 0 ${DOMAINS}
truncate -s 0 ${FILTERED}
truncate -s 0 ${ADS}

python ${YOUTUBE_SCRIPT} > ${DOMAINS}
grep ^r ${DOMAINS} >> ${FILTERED}
sed 's/\s.*$//' ${FILTERED} >> ${ADS}
cat ${ADS} > ${LIST_OUT}

# Looks for googlevideo.com ads already played and adds them to our ignore list.
grep r*.googlevideo.com ${PIHOLE_LOGS} | awk '{print $6}'| grep -v '^googlevideo.com\|redirector' | sort -nr | uniq >> ${LIST_OUT}

# Removes duplicate entries.
perl -i -ne 'print if ! $x{$_}++' ${LIST_OUT}

# Update pi-hole
if [ "$1" = "reload" ]; then
  pihole -g
fi
