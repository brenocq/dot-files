#!/bin/bash

# ---
# Pick a RANDOM wallpaper and apply it to all monitors once hyprpaper is ready.
#
# Why this script exists instead of just hyprpaper.conf:
#   On hyprpaper 0.8.4 the legacy `wallpaper = ,<path>` config line doesn't
#   reliably apply ("Monitor X has no target"). Setting the wallpaper over IPC
#   once hyprpaper answers works reliably. 0.8.x loads images on demand, so no
#   preload step is needed (the preload, unload and listloaded IPC requests
#   were removed; only `wallpaper` and `listactive` remain).
#
# Drop images into WALLPAPER_DIR to add them to the rotation.
# ---

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Trailing slash so find descends even when the dir is a stow symlink.
WALLPAPER=$(find "$WALLPAPER_DIR/" -maxdepth 1 -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | shuf -n 1)
if [ -z "$WALLPAPER" ]; then
    echo "Error: no wallpapers found in $WALLPAPER_DIR." >&2
    exit 1
fi

# Wait until hyprpaper answers over IPC. Checking only that the socket file
# exists is not enough: a stale socket from a previous instance, or one that
# is bound but not yet listening, still refuses the connection.
hyprpaper_ready() { timeout 2 hyprctl hyprpaper listactive >/dev/null 2>&1; }
for _ in $(seq 1 40); do
    hyprpaper_ready && break
    sleep 0.5
done
if ! hyprpaper_ready; then
    echo "Error: hyprpaper not reachable over IPC after 20s." >&2
    exit 1
fi

# Apply the same image to every connected monitor. The empty-monitor form
# (",<path>") is a no-op on 0.8.4, so each monitor is addressed by name.
status=0
for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER" || status=1
done
exit $status
