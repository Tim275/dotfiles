#!/bin/bash
set -eu

[ "$(uname -s)" = "Linux" ] || exit 0

dest="$HOME/.local/share/fonts/JetBrainsMono"
[ -d "$dest" ] && exit 0

command -v fc-cache >/dev/null || { echo "fc-cache fehlt (fontconfig)" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o "$tmp/font.tar.xz"
mkdir "$tmp/font"
tar -xf "$tmp/font.tar.xz" -C "$tmp/font"
mkdir -p "$(dirname "$dest")"
mv "$tmp/font" "$dest"
fc-cache -f "$dest"
