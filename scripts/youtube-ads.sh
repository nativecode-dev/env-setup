#!/bin/bash

echo off
if [ -f /etc/pihole/youtube-filtered.txt ]; then
  rm /etc/pihole/youtube-filtered.txt
fi

if [ -f /etc/pihole/youtube-ads.txt ]; then
  rm /etc/pihole/youtube-ads.txt
fi

curl -s "https://api.hackertarget.com/hostsearch/?q=googlevideo.com" | awk -F, 'NR>1 {print $1}' | sudo tee /etc/pihole/youtube-filtered.txt > /dev/null
sed 's/\s.$//' /etc/pihole/youtube-filtered.txt >> /etc/pihole/youtube-ads.txt
cat /etc/pihole/youtube-ads.txt > /var/www/html/youtube-ads-list.txt

#greps the log for youtube ads and appends to /var/www/html/youtube-ads-list.txt
grep r.googlevideo.com /var/log/pihole.log | awk '{print $6}' | grep -v '^googlevideo.com|redirector' | sort -nr | uniq >> /var/www/html/youtube-ads-list.txt

#removes duplicate lines from /var/www/html/youtube-ads-list.txt
perl -i -ne 'print if ! $x{$_}++' /var/www/html/youtube-ads-list.txt

#updates pihole blacklist/whitelist
pihole -g
