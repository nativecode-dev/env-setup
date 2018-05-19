#! /bin/sh -e

echo "docker-entry.sh"
echo ""
echo "SERVER=$SERVER"
echo "SHARE=$SHARE"
echo "NFSVER=$NFSVER"
echo "OPTIONS=$OPTIONS"
echo "MOUNT=$MOUNT"
echo ""
echo "Making directory $MOUNT"
mkdir -p "$MOUNT"
echo ""
echo "Starting RPC Bind"
rpc.statd & rpcbind -f &
echo "Mounting $SERVER:$SHARE to $MOUNT"
mount.nfs -o "nfsvers=$NFSVER,$OPTIONS" "$SERVER:$SHARE" "$MOUNT"
mount | grep nfs
