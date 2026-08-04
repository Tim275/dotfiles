#!/bin/sh
# Beim ersten Bootstrap ist brew noch nicht im geerbten PATH — ohne das fehlen hier gh & Co.
for b in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$b" ] && eval "$("$b" shellenv)" && break
done

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
  url="https://github.com/iffse/pay-respects/releases/download/v0.8.8/pay-respects-0.8.8-$target.tar.zst"
  # macOS-tar ist libarchive und liest .tar.zst direkt — spart den zstd-Aufruf
  if curl -fsSL "$url" -o "$tmp/pr.tar.zst" && tar -xf "$tmp/pr.tar.zst" -C "$tmp"; then
    mkdir -p "$HOME/.local/bin"
    install -m 755 "$tmp/pay-respects" \
      "$tmp/_pay-respects-module-100-runtime-rules" "$HOME/.local/bin/"
  else
    echo "pay-respects: Download fehlgeschlagen, uebersprungen" >&2
  fi
  rm -rf "$tmp"
fi

command -v gh >/dev/null && ! gh extension list 2>/dev/null | grep -q gh-dash && gh extension install dlvhdr/gh-dash || true
command -v gh >/dev/null && ! gh extension list 2>/dev/null | grep -q gh-poi && gh extension install seachicken/gh-poi || true
command -v gh >/dev/null && ! gh extension list 2>/dev/null | grep -q gh-notify && gh extension install meiji163/gh-notify || true
