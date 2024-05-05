#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

export POLYBAR_WIRED_INTERFACE=$(ip link show | awk '/state UP/ && /enp|eth|eno|ens/{print $2}' | tr -d ':' | head -n 1)
export POLYBAR_WIRELESS_INTERFACE=$(ip link show | awk '/state UP/ && /wlan|wlp|wlx/{print $2}' | tr -d ':' | head -n 1)

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -q main -c "$DIR"/config.ini &
  done
else
    polybar -q main -c "$DIR"/config.ini &
fi
