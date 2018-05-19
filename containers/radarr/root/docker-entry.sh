#! /bin/sh -e

echo "SERVER=$SERVER"
echo "SHARE=$SHARE"
echo "NFSVER=$NFSVER"
echo "OPTIONS=$OPTIONS"
echo "MOUNT=$MOUNT"

echo "Making directory $MOUNT"
mkdir -p "$MOUNT"

echo "Starting RPC Bind"
rpc.statd & rpcbind -f &

echo "Mounting $SERVER:$SHARE to $MOUNT"
mount -t "nfs$NFSVER" -o "nfsvers=$NFSVER,$OPTIONS" "$SERVER:$SHARE" "$MOUNT"
mount | grep nfs
