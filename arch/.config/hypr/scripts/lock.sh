#!/bin/bash
# Path for the screenshots
LOCK_IMG="/tmp/swaylock.png"
LOCK_IMG_BLURRED="/tmp/swaylock_blurred.png"

# Take a screenshot
grim "$LOCK_IMG"

# Blur the screenshot using imagemagick's convert
# 0x8 is a good balance of blur and performance.
convert "$LOCK_IMG" -blur 0x8 "$LOCK_IMG_BLURRED"

# Lock the screen with the blurred screenshot and Gruvbox colors
# We use the pre-blurred image and set --effect-blur to 0x0 to avoid double-blurring.
swaylock \
    --image "$LOCK_IMG_BLURRED" \
    --indicator \
    --indicator-radius 100 \
    --indicator-thickness 7 \
    --ring-color 98971a \
    --key-hl-color b16286 \
    --line-color 00000000 \
    --inside-color d79921 \
    --separator-color 00000000 \

# Remove the screenshots after locking
rm "$LOCK_IMG" "$LOCK_IMG_BLURRED"

