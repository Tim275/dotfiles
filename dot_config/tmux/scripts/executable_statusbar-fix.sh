#!/usr/bin/env bash
# session_path statt pane_current_path: konstante #()-args, kein leeres widget beim pane-wechsel
S="$HOME/.config/tmux/plugins/tokyo-night-tmux/src"
[ -d "$S" ] || exit 0
tmux set -g status-right "#($S/battery-widget.sh)#($S/path-widget.sh '#{session_path}')#($S/music-tmux-statusbar.sh)#($S/netspeed.sh)#($S/git-status.sh '#{session_path}')#($S/wb-git-status.sh '#{session_path}' &)$("$S"/datetime-widget.sh)"
