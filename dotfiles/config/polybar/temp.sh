#!/bin/bash
# Example: extract the CPU temperature from lm-sensors output (adjust according to your sensor labels)
temp=$(sensors | awk '/^Core 0/ { gsub(/\+|°C/, "", $3); print $3; exit }')
echo "CPU: ${temp}°C"
