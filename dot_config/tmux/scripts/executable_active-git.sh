#!/usr/bin/env bash
exec "$HOME/.config/tmux/plugins/tokyo-night-tmux/src/git-status.sh" "$(tmux display -p -F '#{pane_current_path}')"
