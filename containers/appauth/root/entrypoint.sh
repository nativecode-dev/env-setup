#!/bin/sh

# print env
echo "# Configuration:"
echo "LISTEN_PORT=${LISTEN_PORT}"
echo "AUTH_REALM=${AUTH_REALM}"
echo "HTPASSWD_FILE=${HTPASSWD_FILE}"
echo "HTPASSWD=${HTPASSWD}"
echo "FORWARD_PROTOCOL=${FORWARD_PROTOCOL}"
echo "FORWARD_PORT=${FORWARD_PORT}"
echo "FORWARD_HOST=${FORWARD_HOST}"
echo "FORWARD_PATH=${FORWARD_PATH}"
echo ""

# process config for this container
export ESC_DOLLAR='$'
envsubst < /etc/nginx/conf.d/auth.conf > /etc/nginx/conf.d/auth.conf

# print config
echo "# Running with NGINX auth.conf:"
cat /etc/nginx/conf.d/auth.conf
echo ""

# append optional contents of HTPASSWD variable to auth file
if grep -q $HTPASSWD "$HTPASSWD_FILE"; then
  echo "# Running with NGINX auth.htpasswd:"
  cat $HTPASSWD_FILE
  echo ""
else
  echo "# Appending $HTPASSWD to auth.htpasswd:"
  echo $HTPASSWD > $HTPASSWD_FILE
  echo ""
fi

# run nginx in foreground
nginx -g "daemon off;"
