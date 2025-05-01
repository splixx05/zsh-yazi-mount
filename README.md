# USB Mount & Yazi Launcher 🐧📦

A lightweight Bash script to mount USB partitions via `udisksctl`, open them in
[`yazi`](https://github.com/sxyazi/yazi), and unmount them afterward – safe, clean, and user-friendly.

---

## 🔧 Features

- Lists only removable `/dev/sdX` partitions (ignores NVMe/system drives)
- Interactive selection menu with manual quit option
- Warns if a partition is already mounted
- Cleanly extracts the mount path using Bash
- Automatically unmounts after closing `yazi`
- Zero dependencies beyond `udisksctl`, `lsblk`, and `yazi`

---

## 🚀 Installation & Usage

1. Clone or copy the script:

   ```bash
   git clone https://github.com/splixx05/zsh-yazi-mount.git "$ZSH/custom/plugins/zsh-yazi-mount"
   ```

2. Activate the plugin in your /.zshrc under "plugins" like so:

```bash
  plugins=(git ... zsh-mnt ...)
```

or run the installation script from anywhere:

```bash
  ./install.sh
```

3. Usage in terminal:

**For USB type this**

```bash
  $ :usb
```

**For Mobilephone type this**

```bash
  $ :phone
```

4. Browse the mounted device with yazi – once you quit yazi, the device will be automatically unmounted.

## 📋 Requirements

- bash/zsh
- Oh-My-Zsh
- yazi
- udisksctl
- lsblk
- noto-fonts-emoji (or something similar for icons)

Make sure your user has permission to use udisksctl (usually no sudo required for mounting USB devices).

## 🛡️ Safety

- Only shows /dev/sdX devices (ignores NVMe system drives)
- Does not force mount anything
- Checks if device is already mounted before attempting to mount/unmount
- Lets the user abort at any time with q

## 📃 License

### MIT – feel free to fork, improve, and share!

## ❌ Uninstallation

1. Remove the plugin folder:

   ```bash
   rm -rf ~/.oh-my-zsh/custom/plugins/zsh-yazi-mount

   ```

2. Remove zsh-yazi-mount from the plugins=(...) line in your ~/.zshrc.

3. Restart your terminal or run:

```bash
source ~/.zshrc
```

Optional: If you no longer need the additional software (udisksctl, lsblk, noto-fonts-emoji), you can uninstall them using your package manager.
