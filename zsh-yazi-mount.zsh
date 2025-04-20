# open a new tmux window with yazi for the phone

function :phone ()
{
 if [[ -n $TMUX ]]; then
   tmux new-window -n phone && "$ZSH/custom/plugins/zsh-yazi-mount/src/mtp-mnt.zsh"
 else
$ZSH/custom/plugins/zsh-yazi-mount/src/mtp-mnt.zsh
 fi
}


# open a new tmux window with yazi for the usb

function :usb ()
{
 if [[ -n $TMUX ]]; then
   tmux new-window -n usb "$ZSH/custom/plugins/zsh-yazi-mount/src/usb-mnt.zsh"
 else
$ZSH/custom/plugins/zsh-yazi-mount/src/usb-mnt.zsh
 fi
}

