#! /bin/sh -e

echo "FSTYPE=$FSTYPE"
echo "SERVER=$SERVER"
echo "SHARE=$SHARE"
echo "MOUNT_OPTIONS=$MOUNT_OPTIONS"
echo "MOUNTPOINT=$MOUNTPOINT"
echo ""
echo "$SERVER:$SHARE"

echo "Making mount directory $MOUNTPOINT..."
mkdir -p "$MOUNTPOINT"

rpc.statd &
rpcbind -f &
mount -t "$FSTYPE" -o "$MOUNT_OPTIONS" "$SERVER:$SHARE" "$MOUNTPOINT"

mount | grep nfs

while true; do sleep 1000; done
