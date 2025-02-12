#!/bin/bash

case "$1" in
up)
  brightnessctl set +5%
  ;;
down)
  brightnessctl set 5%-
  ;;
*)
  # Display current brightness %
  current=$(brightnessctl g)
  max=$(brightnessctl m)
  percent=$((100 * current / max))
  echo "${percent}%"
  ;;
esac
