#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#polybar -c ~/.config/polybar/top top &
#polybar -c ~/.config/polybar/bottom bottom &
# do you have multiple monitors?
for m in $(polybar --list-monitors | cut -d":" -f1); do
   MONITOR=$m polybar --reload -c ~/.config/polybar/top top &
   MONITOR=$m polybar --reload -c ~/.config/polybar/bottom bottom &
#`    polybar --reload -c ~/.config/polybar/bottom bottom &
done
#else
#   polybar --reload -c ~/.config/polybar/top top &
#   polybar --reload -c ~/.config/polybar/bottom bottom &
#fi
# Launch Polybar
#polybar -c ~/.config/polybar/top top &
#polybar -c ~/.config/polybar/bottom bottom &
#polybar -c ~/.config/polybar/bottom_left bottom_left &
#polybar -c ~/.config/polybar/bottom_right bottom_right &
