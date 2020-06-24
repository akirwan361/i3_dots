#!/usr/bin/env sh

# terminate running cava instances

killall -q cava

# wait until the process is shut down
while pgrep -u $UID -x cava >/dev/null; do sleep 1; done

# now launch in a new instance
xfce4-terminal --hide-borders --hide-scrollbar --execute cava
