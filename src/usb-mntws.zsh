#!/bin/bash

# Script to mount an usb device as a root in $HOME or elsewhere
# 
# --- This script uses the target mountpoint as a root and is still in progress,
# so it comes with no warranty of success or security ! ---

MOUNTPOINT="$HOME/ex/usb"

# -- if you want to define the mountpoint every time you mount,
# comment the line above & uncomment the 2 lines below --

# read -p "Please enter the mount point: " mnpoint
# MOUNTPOINT="mnpoint"

if [ ! -d "$MOUNTPOINT" ]; then
  mkdir -p "$MOUNTPOINT"
  chown "$USER":users "$MOUNTPOINT"
  sudo chmod 755 "$MOUNTPOINT"
fi

# Show devices
echo "Available devices:"
lsblk -o NAME,MODEL,SIZE,TYPE,MOUNTPOINT | grep -i 'sd.*part'

read -p "Please enter the name of device you want to mount: " device

# Mount device
if ! sudo mount "/dev/$device" "$MOUNTPOINT"; then
  echo "Mount failed. Please check:

  - is any usb connected?
  - is any usb unblocked?
  - are you root?

 Process has been cancelled!"
  exit 1
fi

# open yazi
yazi "$MOUNTPOINT"

# unmount when closing yazi
sudo fusermount -u "$MOUNTPOINT" 2>/dev/null || sudo unmount "$MOUNTPOINT"
