# open a new tmux window with yazi for the phone

function :phone() {
  if [[ -n $TMUX ]]; then
    tmux new-window -n phone && "$HOME/.zsh/plugins/local/zsh-yazi-mount/src/mtp-mnt.zsh"
  else
    "$HOME/.zsh/plugins/local/zsh-yazi-mount/src/mtp-mnt.zsh"
  fi
}

# open a new tmux window with yazi for the usb

function :usb() {
  if [[ -n $TMUX ]]; then
    tmux new-window -n usb "$HOME/.zsh/plugins/local/zsh-yazi-mount/src/mtp-mnt.zsh"
  else
    "$HOME/.zsh/plugins/local/zsh-yazi-mount/src/mtp-mnt.zsh"
  fi
}
