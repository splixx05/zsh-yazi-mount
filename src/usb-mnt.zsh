#!/bin/bash

# ------------------
# Mount a selected USB partition using `udisksctl`, open it in `yazi`,
# and automatically unmount after usage.
#
# Author: r!cky
# License: MIT
# GitHub: https://github.com/splixx05/zsh-yazi-mount
#
# Requirements:
# - bash/zsh
# - Oh-My-Zsh
# - yazi
# - udisksctl
# - lsblk
# - noto-fonts-emoji (or something similar for icons)
#
# Usage:
# clone the repo into "$ZSH/custom/plugins/" and activate it on your zshrc under "plugins", e.g.:
# plugins=(git ... zsh-yazi-mount ...)
#
# Features:
# - Lists only removable USB partitions (/dev/sdX)
# - Skips NVMe and system drives
# - Interactive menu with quit option
# - Warns if partition is already mounted
# - Auto-unmounts after closing `yazi`
# ---------------------------------------------------------


# List all removable block partitions (filtering out NVMe/system drives)
echo "📦 Available removable partitions:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -E '^sd.*part'

# Collect only /dev/sdX-type partitions (no nvme, loop, etc.)
mapfile -t devices < <(lsblk -lnpo NAME,TYPE | awk '$1 ~ "/dev/sd" && $2 == "part" {print $1}')

# Exit if no suitable devices are found
if [[ ${#devices[@]} -eq 0 ]]; then
  echo "❌ No suitable USB partitions found."
  exit 1
fi

echo
echo "🔍 Please choose a device to mount (or type 'q' to quit):"

# Manual selection loop with quit option
while true; do
  for i in "${!devices[@]}"; do
    echo "[$((i+1))] ${devices[$i]}"
  done

  read -p "📥 Your choice (1-${#devices[@]} or q): " choice

  if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
    echo "👋 Exited by user."
    exit 0
  elif [[ "$choice" =~ ^[1-9][0-9]*$ ]] && (( choice >= 1 && choice <= ${#devices[@]} )); then
    dev="${devices[$((choice-1))]}"
    break
  else
    echo "⚠️ Invalid input. Please try again or enter 'q' to quit."
  fi
done

# Check if the selected device is already mounted
MOUNTED_PATH=$(lsblk -npo MOUNTPOINT "$dev" | grep -v '^$')

if [[ -n "$MOUNTED_PATH" ]]; then
  echo "⚠️ WARNING: Device $dev is already mounted at: $MOUNTED_PATH"
  read -p "❓ Do you still want to open it in Yazi? [y/N]: " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ Aborted by user."
    exit 0
  fi
  MOUNTPOINT="$MOUNTED_PATH"
else
  # Mount the selected device
  MOUNT_OUTPUT=$(udisksctl mount -b "$dev" 2>&1)
  if [[ $? -ne 0 ]]; then
    echo "❌ Mount failed:"
    echo "$MOUNT_OUTPUT"
    exit 1
  fi

  # Extract the mount path from the output (pure Bash)
  MOUNTPOINT="${MOUNT_OUTPUT##* at }"
  MOUNTPOINT="${MOUNTPOINT%.}"
fi

# Confirm before launching Yazi
echo "✅ Device ready at: $MOUNTPOINT"
read -n 1 -s -r -p "🕹️  Press any key to open Yazi..."
echo

# Launch Yazi in the mounted directory
yazi "$MOUNTPOINT"

# Unmount only if we mounted it ourselves
if [[ -z "$MOUNTED_PATH" ]]; then
  echo "🔌 Unmounting $dev..."
  udisksctl unmount -b "$dev"
fi

echo "✅ Device has been unmounted"
