#!/usr/bin/env bash
exec "$HOME/.config/tmux/plugins/tokyo-night-tmux/src/path-widget.sh" "$(tmux display -p -F '#{pane_current_path}')"
