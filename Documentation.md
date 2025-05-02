---
id: Documentation
aliases: []
tags: []
---

# USB Mount & Yazi Launcher 🐧📦

---

Mount a selected USB partition using `udisksctl`, open it in `yazi`, and automatically unmount after usage.

---

Author: r!cky
License: MIT
GitHub: https://github.com/splixx05/zsh-yazi-mnt.git

---

## Requirements:

- bash/zsh
- udisksctl
- lsblk
- yazi (https://github.com/sxyazi/yazi)
- Oh-My-Zsh
- gum
- noto-fonts-emoji (or something similar for icons)

---

## Usage:

clone the repo into "$ZSH/custom/plugins/" and activate it on your zshrc under "plugins", e.g.:
plugins=(git ... zsh-mnt ...)

---

## Features:

- Lists only removable USB partitions (/dev/sdX)
- Skips NVMe and system drives
- Interactive menu with quit option
- Warns if partition is already mounted
- Auto-unmounts after closing `yazi`

---
