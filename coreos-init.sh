#/bin/bash

# systemd
SYS=/etc/systemd
SYS_NET=$SYSD/network
SYS_SVC=$SYSD/system

# #############################################################################
# SWAP
# #############################################################################

# /var/m/swapfile
SWAP_PATH=/var/vm
SWAP_FILE=swapfile
SWAP="$SWAP_PATH/$SWAP_FILE"

if [ ! -f $SWAP ]; then
  mkdir -p $SWAP_PATH
  fallocate -l 6g $SWAP
  chmod 600 $SWAP
  mkswap $SWAP
fi

# #############################################################################
# SWAP INIT
# #############################################################################

# /etc/systemd/system/var-vm-swapfile.swap
SWAP_INIT_FILE="var-vm-$SWAP_FILE.swap"
SWAP_INIT="$SYS_SVC/$SWAP_INIT_FILE"

if [ ! -f $SWAP_INIT ]; then
  cat <<EOT >> $SWAP_INIT
[Unit]
Description=Turn on swap

[Swap]
What=$SWAP

[Install]
WantedBy=multi-user.target
EOT

  systemctl enable --now $SWAP_INIT_FILE
fi

# #############################################################################
# SWAPPINESS
# #############################################################################

# /etc/sysctl.d/80-swappiness.conf
SWAP_SYSCTL_PATH=/etc/sysctl.d
SWAP_SYSCTL_FILE=80-swappiness.conf
SWAP_SYSCTL="$SWAP_SYSCTL_PATH/$SWAP_SYSCTL_FILE"

if [ ! -f $SWAP_SYSCTL ]; then
  echo 'vm.swappiness=10' | sudo tee $SWAP_SYSCTL
  systemctl restart systemd-sysctl
fi

# #############################################################################
# NFS
# #############################################################################

NFS_DATA=$SYS_SVC/data.mount

if [ ! -f $NFS_DATA ]; then
  cat <<EOT >> $NFS_DATA
[Unit]
Before=remote-fs.target

[Mount]
What=10.132.95.139:/data
Where=/data
Type=nfs

[Install]
WantedBy=remote-fs.target
EOT

  if [ ! -d /data ]; then
    mkdir -p /data
  fi

  systemctl enable --now data.mount
fi
