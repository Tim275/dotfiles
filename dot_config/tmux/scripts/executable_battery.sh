#!/usr/bin/env bash
# Cyberdream tmux - Battery Widget (macOS)
# Shows: icon + percentage

get_battery_info() {
    # macOS only
    if [[ "$(uname)" != "Darwin" ]]; then
        return
    fi

    # Get battery info
    local battery_info
    battery_info=$(pmset -g batt 2>/dev/null)
    [ -z "$battery_info" ] && return

    # Extract percentage
    local percentage
    percentage=$(echo "$battery_info" | grep -oE '[0-9]+%' | head -1 | tr -d '%')
    [ -z "$percentage" ] && return

    # Check if charging
    local charging=""
    if echo "$battery_info" | grep -q "AC Power"; then
        charging="󰂄"
    fi

    # Choose icon based on level
    local icon
    if [ -n "$charging" ]; then
        icon="󰂄"
    elif [ "$percentage" -ge 90 ]; then
        icon="󰁹"
    elif [ "$percentage" -ge 70 ]; then
        icon="󰂀"
    elif [ "$percentage" -ge 50 ]; then
        icon="󰁾"
    elif [ "$percentage" -ge 30 ]; then
        icon="󰁼"
    elif [ "$percentage" -ge 10 ]; then
        icon="󰁺"
    else
        icon="󰂃"
    fi

    echo "$icon $percentage%"
}

get_battery_info
