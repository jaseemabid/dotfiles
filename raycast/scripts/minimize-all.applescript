#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Minimize All Windows
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🪟
# @raycast.packageName System
# Documentation:
# @raycast.author Ernest Ojeh
# @raycast.authorURL https://github.com/namzo
# @raycast.description Minimizes all windows

# https://hartenfeller.dev/blog/mac-minimize-all-windows
tell application "System Events"
  set theProcesses to (every process whose visible is true and name is not "Finder")
  repeat with proc in theProcesses
    tell proc
      set theWindows to every window
      repeat with win in theWindows
        set value of attribute "AXMinimized" of win to true
      end repeat
    end tell
  end repeat
end tell
tell application "Finder" to set collapsed of windows to true
