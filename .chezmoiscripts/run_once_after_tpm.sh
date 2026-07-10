#!/bin/sh
dir="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$dir" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$dir"
  command -v tmux >/dev/null && "$dir/bin/install_plugins" || true
fi
