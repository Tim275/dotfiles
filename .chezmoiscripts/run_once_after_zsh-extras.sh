#!/bin/sh
dir="$HOME/.config/zsh/plugins/fzf-tab"
if [ ! -d "$dir" ]; then
  git clone --depth 1 https://github.com/Aloxaf/fzf-tab "$dir"
fi

if ! command -v pay-respects >/dev/null; then
  arch=$(uname -m)
  case "$arch" in
    arm64|aarch64) target="aarch64-apple-darwin" ;;
    *) target="x86_64-apple-darwin" ;;
  esac
  tmp=$(mktemp -d)
  curl -sL "https://github.com/iffse/pay-respects/releases/download/v0.8.8/pay-respects-0.8.8-$target.tar.zst" -o "$tmp/pr.tar.zst"
  zstd -dq "$tmp/pr.tar.zst" -o "$tmp/pr.tar" && tar -xf "$tmp/pr.tar" -C "$tmp"
  mkdir -p "$HOME/.local/bin"
  install -m 755 "$tmp/pay-respects" "$tmp/_pay-respects-module-100-runtime-rules" "$HOME/.local/bin/"
  rm -rf "$tmp"
fi
