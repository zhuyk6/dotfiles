#!/bin/bash

# ----------------------------------------------------- 
# Check if the script is called with 'select' argument
# ----------------------------------------------------- 
if [[ "$1" == "select" ]]; then
    # select the wallpaper
    selected=$(ls -1 ~/Pictures/wallpaper | grep "jpg" | tofi --prompt-text "Wallpapers:")
fi

# ----------------------------------------------------- 
# Select random (or select) wallpaper and create color scheme
# ----------------------------------------------------- 
wal -q -i ~/Pictures/wallpaper/$selected

# ----------------------------------------------------- 
# Load current pywal color scheme
# ----------------------------------------------------- 
source "$HOME/.cache/wal/colors.sh"

# ----------------------------------------------------- 
# Copy selected wallpaper into .cache folder
# ----------------------------------------------------- 
cp $wallpaper ~/.cache/current_wallpaper.jpg

# ----------------------------------------------------- 
# get wallpaper image name
# ----------------------------------------------------- 
newwall=$(echo $wallpaper | sed "s|$HOME/Pictures/wallpaper/||g")

# ----------------------------------------------------- 
# Set the new wallpaper
# ----------------------------------------------------- 
hyprctl hyprpaper preload $wallpaper
hyprctl hyprpaper wallpaper ",$wallpaper"

# ----------------------------------------------------- 
# Send notification
# ----------------------------------------------------- 
notify-send "Colors and Wallpaper updated" "with image $newwall"

# ----------------------------------------------------- 
# Check if the script is called with 'update' argument
# ----------------------------------------------------- 
if [[ "$1" == "update" || "$2" == "update" ]]; then
    # restart waybar
    ~/dotfiles/waybar/launch.sh
    notify-send "Waybar has been restarted."
fi

sleep 1

echo "DONE!"
