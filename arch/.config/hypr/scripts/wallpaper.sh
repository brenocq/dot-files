#!/bin/bash

# ---
# Wait for hyprpaper to be ready.
# Apply the *same* random wallpaper to *all* monitors.
# ---

# Function to wait for the hyprpaper socket
wait_for_socket() {
    local max_attempts=10
    local attempt=1
    local socket_path="$HYPRLAND_INSTANCE_SIGNATURE/.hyprpaper.sock"

    while [ $attempt -le $max_attempts ]; do
        if [ -S "/run/user/$UID/hypr/$socket_path" ]; then
            return 0
        fi
        sleep 1
        ((attempt++))
    done

    echo "Error: hyprpaper socket not found after $max_attempts seconds." >&2
    return 1
}

# Wait for the socket
if ! wait_for_socket; then
    exit 1
fi

# --- Your original script logic ---
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Tell hyprpaper to preload the new wallpaper
hyprctl hyprpaper preload "$RANDOM_WALLPAPER"

# Apply the wallpaper to all monitors
for monitor in $(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }'); do
    hyprctl hyprpaper wallpaper "$monitor, $RANDOM_WALLPAPER"
done

# Unload the old (unused) wallpapers
hyprctl hyprpaper unload all
