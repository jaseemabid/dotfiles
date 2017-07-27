#!/bin/bash

# Load custom key bindings
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Set a wallpaper
xsetroot -solid '#002b36'

alacritty &

exec xmonad
