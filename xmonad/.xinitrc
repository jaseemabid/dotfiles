#!/bin/bash

# Load custom key bindings
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Set a wallpaper
xsetroot -solid '#002b36'

# Increase mouse scrolling speed
imwheel -k -b "45"

alacritty &

exec xmonad
