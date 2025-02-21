#!/bin/bash
# brightness.sh
#
# This script adjusts the brightness using brightnessctl and then sends
# a dunst notification with the new brightness percentage.
#
# Usage examples:
#   ./brightness-notify.sh +10   # Increase brightness by 10%
#   ./brightness-notify.sh -10   # Decrease brightness by 10%
#
# Dependencies:
#   - brightnessctl (or another brightness control utility)
#   - dunst and dunstify (for notifications)
#
# Note: We set the app name to "brightness" so that you can create a
#       matching rule in your dunst config to position these notifications
#       at the middle bottom of your screen.

# Ensure one argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [+/-]percentage"
  exit 1
fi

# Adjust brightness (the argument should be like +10 or -10)
brightnessctl set "$1"%

# Wait a short moment for the change to take effect
sleep 0.1

# Get current brightness information:
# brightnessctl returns the current and maximum brightness as integers.
current=$(brightnessctl get)
max=$(brightnessctl max)

# Calculate the brightness percentage (integer division)
percent=$((100 * current / max))

# Send a notification using dunstify.
# -r 9999 : Replace any previous brightness notification (so they don’t stack)
# -u low  : Use low urgency (feel free to change)
# -a brightness : Set the app name to "brightness" (see note below)
# -i display-brightness : Specify an icon (change or remove as desired)
dunstify -r 9999 -u low -a brightness -i display-brightness "Brightness" "${percent}%"
