#!/bin/bash
# For Aerospace integration
SPACE=$(aerospace list-workspaces --focused 2>/dev/null || echo "1")
sketchybar --set $NAME label="[$SPACE]"
