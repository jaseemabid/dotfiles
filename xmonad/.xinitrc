#!/bin/bash

# Set a wallpaper
feh --bg-scale .images/realartistsship2560x1440.jpg

# Fire up apps
terminator &

exec xmonad
