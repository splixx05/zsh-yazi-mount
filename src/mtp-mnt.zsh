#!/bin/bash

# --- This script uses the target mountpoint as a root and is still in progress,
# so it comes with no warranty of success or security ! ---

MOUNTPOINT="$HOME/ex/phone"

if [ ! -d "$MOUNTPOINT" ]; then
  mkdir -p "$MOUNTPOINT"
  chown "$USER":users "$MOUNTPOINT"
  sudo chmod 755 "$MOUNTPOINT"
fi

# trigger phone to confirm action
simple-mtpfs --device 1 "$MOUNTPOINT" 2>/dev/null && fusermount -u "$MOUNTPOINT"
read -p "Please check your phone & confirm with [Enter]"

# mount phone
simple-mtpfs --device 1 "$MOUNTPOINT" || {
  echo "Mount failed. Please check:
  
  - is your phone connected?
  - is your phone unblocked?
  - are you root?

 Process has been cancelled!"
  exit 1
}

# open yazi
yazi "$MOUNTPOINT"

# unmount when closing yazi
fusermount -u "$MOUNTPOINT"
