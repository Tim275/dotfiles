#!/bin/bash
MEMORY=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | cut -d% -f1)
sketchybar --set $NAME label="${MEMORY}%"
