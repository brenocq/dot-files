#!/bin/bash
# Brightness control script for both laptop and external monitors

# Configuration
LAPTOP_DEVICE="amdgpu_bl1"
EXTERNAL_BUS="6"  # Dell P2723DE on /dev/i2c-6
STEP="5"

# Function to change laptop brightness
change_laptop_brightness() {
    if [ "$1" = "up" ]; then
        brightnessctl -d "$LAPTOP_DEVICE" set "${STEP}%+"
    elif [ "$1" = "down" ]; then
        brightnessctl -d "$LAPTOP_DEVICE" set "${STEP}%-"
    fi
}

# Function to change external monitor brightness
change_external_brightness() {
    # Get current brightness
    current=$(ddcutil getvcp 10 -b "$EXTERNAL_BUS" --terse | cut -d' ' -f4)

    if [ "$1" = "up" ]; then
        new=$((current + STEP))
        [ $new -gt 100 ] && new=100
    elif [ "$1" = "down" ]; then
        new=$((current - STEP))
        [ $new -lt 0 ] && new=0
    fi

    ddcutil setvcp 10 "$new" -b "$EXTERNAL_BUS" --noverify
}

# Main logic
case "$1" in
    up|down)
        # Change both displays in parallel for better responsiveness
        change_laptop_brightness "$1" &
        change_external_brightness "$1" &
        wait
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac
