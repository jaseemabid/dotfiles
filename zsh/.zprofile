[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
[[ -s "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"

eval $(gpg-agent --daemon)
