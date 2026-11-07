#!/bin/bash

# ---
# Dim the external monitors to half their usual brightness at night.
#
# Sets each monitor's own backlight over DDC/CI (VCP feature 10), the same
# setting as its buttons, so the screens give off less light instead of only
# showing darker pixels. Runs at Hyprland start and from night-brightness.timer
# at 06:00 and 19:00, the same window as the blue light filter in
# hyprsunset.conf; keep the two schedules in sync.
#
# Needs ddcutil and the i2c-dev kernel module (see install_arch.sh).
# ---

DAY_BRIGHTNESS=50
NIGHT_BRIGHTNESS=25

hour=$(date +%-H)
if (( hour >= 19 || hour < 6 )); then
    brightness=$NIGHT_BRIGHTNESS
else
    brightness=$DAY_BRIGHTNESS
fi

# One display number per monitor that answers DDC/CI.
for display in $(ddcutil detect --terse 2>/dev/null | awk '/^Display/ {print $2}'); do
    ddcutil --display "$display" setvcp 10 "$brightness"
done
