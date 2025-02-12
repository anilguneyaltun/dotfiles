#!/bin/bash
# Example: extract the CPU temperature from lm-sensors output (adjust according to your sensor labels)
temp=$(sensors | grep -i 'fan1:' | awk '{print $2}')
echo "${temp} RPM"
