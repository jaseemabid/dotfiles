#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# set the cursor -- xmonad has none by default
xsetroot -cursor_name left_ptr

# load your wallpaper with feh
feh --bg-fill /home/jaseem/dotfiles/xmonad/archblue.png

# load xmonad
# xmonad

# exec i3
exec i3 -V >> ~/.i3/i3log 2>&1
