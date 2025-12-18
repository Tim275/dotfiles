#!/bin/bash
CPU=$(top -l 1 | grep -E "^CPU" | awk '{print $3}' | cut -d% -f1)
sketchybar --set $NAME label="${CPU}%"
