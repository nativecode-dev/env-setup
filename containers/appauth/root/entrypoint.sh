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

if [ ! -f $HTPASSWD_FILE ]; then
    $HTPASSWD > $HTPASSWD_FILE
fi

# print config
echo "# Running with NGINX auth.conf:"
cat /etc/nginx/conf.d/auth.conf
echo ""

# print auth
echo "# Running with NGINX auth.conf:"
cat $HTPASSWD_FILE
echo ""

# run nginx in foreground
nginx -g "daemon off;"
