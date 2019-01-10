#! /bin/sh -e

echo "SERVER=$SERVER"
echo "SHARE=$SHARE"
echo "MOUNT_OPTIONS=$MOUNT_OPTIONS"
echo "MOUNT_POINT=$MOUNT_POINT"
echo "MOUNT_TYPE=$MOUNT_TYPE"
echo ""
echo "Will mount $SERVER:$SHARE as $MOUNT_TYPE to $MOUNT_POINT using $MOUNT_OPTIONS"

echo "Making mount directory $MOUNT_POINT..."
mkdir -p "$MOUNT_POINT"

rpc.statd &
rpcbind -f &
mount -t "$MOUNT_TYPE" -o "$MOUNT_OPTIONS" "$SERVER:$SHARE" "$MOUNT_POINT"

mount | grep nfs

while true; do sleep 10; done
