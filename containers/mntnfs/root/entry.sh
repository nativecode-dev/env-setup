#! /bin/sh -e

echo "SERVER=$SERVER"
echo "SHARE=$SHARE"
echo "MOUNT_OPTIONS=$MOUNT_OPTIONS"
echo "MOUNT_POINT=$MOUNT_POINT"
echo ""
echo "$SERVER:$SHARE"

echo "Making mount directory $MOUNT_POINT..."
mkdir -p "$MOUNT_POINT"

rpc.statd &
rpcbind -f &
mount.nfs -o "$MOUNT_OPTIONS" "$SERVER:$SHARE" "$MOUNT_POINT"

mount | grep nfs

while true; do sleep 1000; done
