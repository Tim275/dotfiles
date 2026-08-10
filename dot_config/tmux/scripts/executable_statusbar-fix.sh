#!/usr/bin/env bash
# widgets ohne format-args: konstante #()-strings, kein leeres widget beim pane-wechsel
S="$HOME/.config/tmux/plugins/tokyo-night-tmux/src"
W="$HOME/.config/tmux/scripts"
[ -d "$S" ] || exit 0
tmux set -g status-right "#($S/battery-widget.sh)#($W/active-path.sh)#($S/music-tmux-statusbar.sh)#($S/netspeed.sh)#($W/active-git.sh)$("$S"/datetime-widget.sh)"
