#!/bin/bash

# Load custom key bindings
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Set a wallpaper
feh --bg-scale .images/night.jpg

# Fire up apps
terminator &

exec xmonad
