#!/bin/bash

# Load custom key bindings
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Set a wallpaper and mouse pointer
xsetroot -solid '#2e3440'
xsetroot -cursor_name left_ptr

feh --bg-fill ~/Pictures/wp.jpg || true

# Disable nm-applet and trayer. This doesnt work well at all.
#
# if [ -z "$(pgrep nm-applet)" ] ; then
#    nm-applet &
# fi
#
# Looks like trayer needs to be started after nm-applet etc.
# trayer --align right  --SetPartialStrut true --width 4 --height 30 \
#       --transparent true --tint 0x002b36 --alpha 0 &

exec xmonad
