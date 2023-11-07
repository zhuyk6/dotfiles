#!/bin/bash
#   ____ _ _       _     _     _    
#  / ___| (_)_ __ | |__ (_)___| |_  
# | |   | | | '_ \| '_ \| / __| __| 
# | |___| | | |_) | | | | \__ \ |_  
#  \____|_|_| .__/|_| |_|_|___/\__| 
#           |_|                     
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

case $1 in
    d) cliphist list | wofi --dmenu -p "Delete a history" | cliphist delete
       ;;

    w) if [ `echo -e "Clear\nCancel" | wofi --dmenu` == "Clear" ] ; then
            cliphist wipe
       fi
       ;;

    *) cliphist list | wofi --dmenu -p "Choose a history" | cliphist decode | wl-copy
       ;;
esac
