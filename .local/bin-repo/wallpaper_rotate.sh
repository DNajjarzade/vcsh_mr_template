#!/bin/bash

# Set the wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/wallpaper"

# Choose a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Set the wallpaper with feh
feh --bg-fill "$WALLPAPER"

# Generate color scheme with pywal
wal -n -i "$WALLPAPER"

# Restart polybar
# polybar-msg cmd restart

