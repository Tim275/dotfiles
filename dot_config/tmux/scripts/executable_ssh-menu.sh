#!/usr/bin/env bash
host=$(grep -iE '^Host ' ~/.ssh/config 2>/dev/null | awk '{print $2}' | grep -vE '[*?]' | sort -u | fzf --prompt="ssh > " --height=100%)
[ -z "$host" ] && exit 0
tmux new-window -n "$host" "ssh $host"
