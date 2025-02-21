#!/bin/bash
# volume-notify.sh
#
# This script adjusts the volume using wpctl (PipeWire) or toggles mute,
# then sends a dunst notification displaying the current volume as a progress bar
# (or "Muted" if muted).
#
# Usage examples:
#   ./volume-notify.sh +10    # Increase volume by 10%
#   ./volume-notify.sh -10    # Decrease volume by 10%
#   ./volume-notify.sh mute   # Toggle mute state
#
# Dependencies:
#   - wpctl (PipeWire command line utility)
#   - dunst and dunstify (for notifications)
#
# Note: We set the app name to "volume" for notification rules in dunst.

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [+/-]percentage or mute"
  exit 1
fi

arg="$1"

# Function to retrieve volume info and update notification details.
get_volume_info() {
  local info volume_current volume_percent status icon
  info=$(wpctl get-volume @DEFAULT_SINK@)

  # Check if muted
  if echo "$info" | grep -qi "muted"; then
    status="Muted"
    volume_percent=0
    icon="audio-volume-muted"
  else
    # Extract the current volume value (a float between 0 and 1)
    volume_current=$(echo "$info" | grep -oP 'Volume:\s*\K[0-9.]+')
    volume_percent=$(awk "BEGIN {printf \"%d\", $volume_current * 100}")
    status="${volume_percent}%"

    # Choose an icon based on volume level.
    if [ "$volume_percent" -ge 66 ]; then
      icon="audio-volume-high"
    elif [ "$volume_percent" -ge 33 ]; then
      icon="audio-volume-medium"
    else
      icon="audio-volume-low"
    fi
  fi
  # Export values for use outside the function.
  echo "$volume_percent|$status|$icon"
}

# If the argument is "mute", toggle the mute state.
if [ "$arg" = "mute" ]; then
  wpctl set-mute @DEFAULT_SINK@ toggle
  sleep 0.1

  # Get updated volume information.
  IFS="|" read -r vol stat icon <<<"$(get_volume_info)"
  dunstify -r 9999 -u low -a volume -h "$vol" "Volume" "$stat" -i "$icon"
  exit 0
fi

# Otherwise, assume a relative volume adjustment (e.g. +10 or -10).

# Get the current volume as a float (0 to 1)
current=$(wpctl get-volume @DEFAULT_SINK@ | grep -oP 'Volume:\s*\K[0-9.]+')
if [ -z "$current" ]; then
  echo "Could not retrieve current volume."
  exit 1
fi

# Convert to an integer percentage.
current_percent=$(awk "BEGIN {printf \"%d\", $current * 100}")

# Calculate the new volume percentage using the adjustment.
new_volume=$((current_percent + arg))

# Clamp the volume between 0 and 100.
if [ $new_volume -gt 100 ]; then
  new_volume=100
elif [ $new_volume -lt 0 ]; then
  new_volume=0
fi

# Set the new volume using wpctl.
wpctl set-volume @DEFAULT_SINK@ "${new_volume}%"
sleep 0.1

# Retrieve updated volume info.
IFS="|" read -r vol stat icon <<<"$(get_volume_info)"
# When adjusting volume, ensure the progress bar reflects the new percentage.
dunstify -r 9999 -u low -a volume -h "$new_volume" "Volume" "$stat" -i "$icon"
