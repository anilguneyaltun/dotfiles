#!/bin/bash
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Check if brightnessctl is available
if ! command -v brightnessctl &>/dev/null; then
  notify-send "Error" "brightnessctl not found. Install it using: sudo pacman -S brightnessctl"
  exit 1
fi

# Check if the user has permission to control brightness
if ! brightnessctl get &>/dev/null; then
  notify-send "Permission Denied" "Run as root or add your user to the 'video' group."
  exit 1
fi

# Get current brightness percentage
CURRENT_BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
PERCENT=$((CURRENT_BRIGHTNESS * 100 / MAX_BRIGHTNESS))

# Define brightness levels
OPTIONS="10%\n25%\n50%\n75%\n100%\n+10%\n-10%"

# Show Rofi menu
CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -p "Brightness ($PERCENT%)")

# Adjust brightness based on selection
case "$CHOSEN" in
"10%") brightnessctl set 10% ;;
"25%") brightnessctl set 25% ;;
"50%") brightnessctl set 50% ;;
"75%") brightnessctl set 75% ;;
"100%") brightnessctl set 100% ;;
"+10%") brightnessctl set +10% ;;
"-10%") brightnessctl set 10%- ;;
*) exit 1 ;; # Exit if no valid option selected
esac

# Send notification about the new brightness level
NEW_BRIGHTNESS=$(brightnessctl get)
NEW_PERCENT=$((NEW_BRIGHTNESS * 100 / MAX_BRIGHTNESS))
notify-send "Brightness Changed" "New brightness: $NEW_PERCENT%"
