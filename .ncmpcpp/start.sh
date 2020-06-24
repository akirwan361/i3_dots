#!/bin/zsh

# kill the processes if it's running
#killall -q ncmpcpp

# wait until it shuts down
#while pgrep -u $UID -x ncmpcpp >/dev/null; do sleep 1; done

# check if mpd is running
if pidof -x mpd -o $$ >/dev/null; then
   sleep 0.5
##   exit 1
else
   mpd $HOME/.config/mpd/mpd.conf && mpc update
fi

# spawn in new terminal
script="ncmpcpp --config $HOME/.ncmpcpp/config"
xfce4-terminal --hide-borders --hide-scrollbar --execute $script
