#!/bin/bash

# Directory containing your wallpapers
WALL_DIR="$HOME/Pictures/wallpapers"

# Find a random wallpaper file
RANDOM_WALLPAPER=$(find "$WALL_DIR" -type f | shuf -n 1)

# Check if a wallpaper was found
if [ -z "$RANDOM_WALLPAPER" ]; then
    echo "No wallpapers found in $WALL_DIR"
    exit 1
fi

# --- hyprpaper ---

# Preload the new wallpaper
hyprctl hyprpaper preload "$RANDOM_WALLPAPER"

# Get all connected monitor names
MONITORS=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

# Set the wallpaper for each monitor
for MON in $MONITORS; do
    hyprctl hyprpaper wallpaper "$MON,$RANDOM_WALLPAPER"
done
