#!/bin/bash
set -xe

# startx
service dbus start &>/dev/null &
Xorg -dpi 96 -noreset -nolisten tcp +extension GLX +extension RANDR +extension RENDER -logfile /tmp/Xorg.100.log "$DISPLAY" &>/dev/null &

# novnc
x11vnc -q -nopw -forever -bg > /dev/null 2>&1 &
nohup /opt/noVNC-1.0.0/utils/launch.sh >/dev/null 2>&1 &

if [ ! -z "$CREATE_DB" ] && [ "$CREATE_DB" == "true" ] ; then
  ./scripts/load-database-from-files.sh
fi

sleep infinity