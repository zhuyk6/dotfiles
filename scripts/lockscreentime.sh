#/bin/sh
#  ___    _ _      _   _                 
# |_ _|__| | | ___| |_(_)_ __ ___   ___  
#  | |/ _` | |/ _ \ __| | '_ ` _ \ / _ \ 
#  | | (_| | |  __/ |_| | | | | | |  __/ 
# |___\__,_|_|\___|\__|_|_| |_| |_|\___| 
#                                        
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

timeswaylock=600
timeoff=660
timesleep=900

if [ -f "/usr/bin/swayidle" ]; then
    echo "swayidle is installed."
    
    swayidle -w \
      timeout $timeswaylock 'swaylock -f' \
      timeout $timeoff 'if pgrep swaylock; then hyprctl dispatch dpms off; fi' \
      # resume 'hyprctl dispatch dpms on' \
      before-sleep 'swaylock -f'
else
    echo "swayidle not installed."
fi;
