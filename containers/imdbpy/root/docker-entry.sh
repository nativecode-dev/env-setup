#!/bin/sh

set -e

if [ ! -d /data ]; then
  echo "Creating data directory..."
  echo "-------------------------------------------------------------------------"
  mkdir -p /data
fi

cd /data

echo "Downloading latest IMDB data files..."
echo "-------------------------------------------------------------------------"

wget -r \
  --accept="*.gz" \
  --no-directories \
  --no-host-directories \
  --level 1 "$IMDB_FTP" \
  ;

echo "Running import against data files..."
echo "-------------------------------------------------------------------------"

imdbpy2sql.py \
  -d /data/ \
  -u "mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST/$MYSQL_DATABASE"
  ;

echo "done."
