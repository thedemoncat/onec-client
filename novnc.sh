#!/bin/bash

x11vnc -q -nopw -forever -bg > /dev/null 2>&1
nohup /opt/noVNC-1.0.0/utils/launch.sh >/dev/null 2>&1 &