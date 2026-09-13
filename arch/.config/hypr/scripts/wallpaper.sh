#!/bin/bash

# ---
# Set a FIXED wallpaper on all monitors once hyprpaper is ready.
#
# Why this script exists instead of just hyprpaper.conf:
#   On this setup (hyprpaper 0.8.4) the `wallpaper = ,<path>` line in
#   hyprpaper.conf doesn't reliably apply ("Monitor X has no target") because
#   it races the async image preload. Setting the wallpaper over IPC after the
#   socket is up works reliably. hyprpaper.conf still `preload`s the image.
#
# To change the wallpaper, edit WALLPAPER below.
# ---

WALLPAPER="$HOME/Pictures/wallpapers/golden-duck.jpg"

# Wait for the hyprpaper IPC socket to appear.
SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.hyprpaper.sock"
for _ in $(seq 1 20); do
    [ -S "$SOCKET" ] && break
    sleep 0.5
done
if [ ! -S "$SOCKET" ]; then
    echo "Error: hyprpaper socket not found." >&2
    exit 1
fi

# Make sure the image is loaded (hyprpaper.conf also preloads it; the IPC
# preload is rejected on some hyprpaper builds, so don't fail on it).
hyprctl hyprpaper preload "$WALLPAPER" >/dev/null 2>&1

# Apply to every connected monitor.
for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
done
