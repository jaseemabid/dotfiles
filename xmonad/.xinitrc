#!/bin/bash

# Set a wallpaper
feh --bg-scale .images/night.jpg

# Fire up apps
terminator &

exec xmonad
