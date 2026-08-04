#!/bin/sh
# Beim ersten Bootstrap ist brew noch nicht im geerbten PATH — ohne das fehlt hier tmux.
for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$b" ] && eval "$("$b" shellenv)" && break
done

dir="$HOME/.config/tmux/plugins/tpm"
[ -d "$dir" ] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$dir"

if command -v tmux >/dev/null; then
  "$dir/bin/install_plugins"
else
  echo "tmux nicht gefunden — TPM-Plugins fehlen, in tmux mit prefix+I nachholen" >&2
fi
