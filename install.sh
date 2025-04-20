#!/bin/bash

# Plugin details
PLUGIN_NAME="zsh-yazi-mount"
ZSHRC="$HOME/.zshrc"
TARGET="${ZSH:-$HOME/.oh-my-zsh}/custom/plugins"

# Check if --yes argument was passed
AUTO_YES=false
if [[ "$1" == "--yes" ]]; then
  AUTO_YES=true
fi

if [[ ! -d "$TARGET" ]]; then
  echo "❗ Plugin target path $TARGET does not exist. Is Oh My Zsh installed?"
  exit 1
fi

echo "🚀 Starting installation of $PLUGIN_NAME..."

# Copy plugin folder if not already present
if [[ ! -d "$TARGET/$PLUGIN_NAME" ]]; then
  echo "📁 Copying plugin to $TARGET/$PLUGIN_NAME ..."
  mkdir -p "$TARGET"
  cp -r . "$TARGET/$PLUGIN_NAME"
else
  echo "✅ Plugin already exists at $TARGET/$PLUGIN_NAME"
fi

# Make source scripts executable
echo "🔧 Making source scripts executable..."
for file in mtp-mnt.zsh usb-mnt.zsh usb-mntws.zsh; do
  chmod +x "$TARGET/$PLUGIN_NAME/src/$file"
done

# Add plugin to .zshrc if not already present
if grep -q "^plugins=" "$ZSHRC"; then
  if grep -q "plugins=.*\b$PLUGIN_NAME\b" "$ZSHRC"; then
    echo "🟡 Plugin $PLUGIN_NAME is already listed in .zshrc."
  else
    echo "➕ Adding $PLUGIN_NAME to plugins in .zshrc..."
    cp "$ZSHRC" "$ZSHRC.bak" # Backup
    sed -i "/^plugins=/ s/)/ $PLUGIN_NAME)/" "$ZSHRC"
    echo "✅ Plugin added to .zshrc."
  fi
else
  echo "⚠️ No 'plugins=' line found in .zshrc. Please add '$PLUGIN_NAME' manually."
fi

# List of required software
REQUIRED_SOFTWARE=("udisksctl" "lsblk" "noto-fonts-emoji")

# Check if a package is installed (command or font)
is_installed() {
  local software=$1

  if [[ "$software" == "noto-fonts-emoji" ]]; then
    # Check if Noto Emoji font is installed
    fc-list | grep -qi "Noto.*Emoji"
    return $?
  else
    command -v "$software" &>/dev/null
    return $?
  fi
}

# Install software depending on available package manager
install_software() {
  local software=$1

  echo "⚠️  $software is not installed."
  if $AUTO_YES; then
    answer="y"
  else
    read -p "👉 Do you want to install $software? (y/N): " answer
  fi

  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "⏳ Installing $software..."
    if command -v apt &>/dev/null; then
      sudo apt update && sudo apt install -y "$software"
    elif command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm "$software"
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y "$software"
    elif command -v yay &>/dev/null; then
      yay -Sy --noconfirm "$software"
    else
      echo "❌ No supported package manager found. Please install $software manually."
    fi
  else
    echo "⛔ Skipped installation of $software."
  fi
}

# Main loop through required software
for software in "${REQUIRED_SOFTWARE[@]}"; do
  if is_installed "$software"; then
    echo "✅ $software is already installed."
  else
    install_software "$software"
  fi
done

if [[ "$SHELL" == *"zsh" ]]; then
  echo "🔄 Reloading your .zshrc..."
  source "$ZSHRC"
else
  echo "🔁 Please run 'source ~/.zshrc' manually or restart your shell."
fi

echo "🎉 Installation has been completed!"
