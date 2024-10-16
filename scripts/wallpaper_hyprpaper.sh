#!/bin/bash
#                   _  _                                  
#                  | || |                                 
# __      __  __ _ | || | _ __    __ _  _ __    ___  _ __ 
# \ \ /\ / / / _` || || || '_ \  / _` || '_ \  / _ \| '__|
#  \ V  V / | (_| || || || |_) || (_| || |_) ||  __/| |   
#   \_/\_/   \__,_||_||_|| .__/  \__,_|| .__/  \___||_|   
#                        | |           | |                
#                        |_|           |_|                
#  _                                                          
# | |                                                         
# | |__   _   _  _ __   _ __  _ __    __ _  _ __    ___  _ __ 
# | '_ \ | | | || '_ \ | '__|| '_ \  / _` || '_ \  / _ \| '__|
# | | | || |_| || |_) || |   | |_) || (_| || |_) ||  __/| |   
# |_| |_| \__, || .__/ |_|   | .__/  \__,_|| .__/  \___||_|   
#          __/ || |          | |           | |                
#         |___/ |_|          |_|           |_|                

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

# ----------------------------------------------------- 
# Generate blurred wallpaper
# ----------------------------------------------------
magick ~/.cache/current_wallpaper.jpg -scale 10% -blur 0x5 -resize 1000%  ~/.cache/blurred_wallpaper.png

# ----------------------------------------------------- 
# Generate square wallpaper
# ----------------------------------------------------- 
magick ~/.cache/current_wallpaper.jpg -gravity Center -extent 1:1 ~/.cache/square_wallpaper.png
