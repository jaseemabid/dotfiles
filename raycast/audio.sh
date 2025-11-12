#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Toggle Audio Devices
# @raycast.mode silent
# @raycast.packageName Audio
# @raycast.icon 🎧

# Detect if AirPods are connected
if SwitchAudioSource -a | grep -q "Jaseem’s AirPods"; then
  # AirPods are connected → use AirPods output + LG display mic
  SwitchAudioSource -s "Jaseem’s AirPods" -t output
  SwitchAudioSource -s "LG UltraFine Display Audio" -t input
  echo "Using AirPods output + LG mic"
else
  echo "AirPods Not connected"
fi
