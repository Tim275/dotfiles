#!/usr/bin/env bash
# NetBird (homelab) oder Tailscale (Arbeit). Still auf Maschinen ohne VPN-Setup,
# aber laut wenn ein eingerichtetes VPN weg ist — Ausfall soll nicht unsichtbar sein.

cache="/tmp/.tmux-vpn"
mtime=$(stat -f %m "$cache" 2>/dev/null || stat -c %Y "$cache" 2>/dev/null || echo 0)
if [ ! -f "$cache" ] || [ $(($(date +%s) - mtime)) -ge 15 ]; then
  ok=$'\U000F0582'  # nf-md-vpn
  bad=$'\U000F099D' # nf-md-shield-off
  out=""

  if [ -f /Library/LaunchDaemons/netbird.plist ] ||
    [ -f /etc/systemd/system/netbird.service ] ||
    [ -f /usr/lib/systemd/system/netbird.service ]; then
    if timeout 2 netbird status 2>/dev/null | grep -q '^Management: Connected'; then
      out="#[fg=#9aa5ce]$ok#[default]"
    else
      out="#[fg=#f7768e]$bad VPN#[default]"
    fi
  elif timeout 2 tailscale status >/dev/null 2>&1; then
    out="#[fg=#9aa5ce]$ok#[default]"
  fi

  printf '%s' "$out" >"$cache"
fi
cat "$cache" 2>/dev/null
