#!/usr/bin/env bash
# widgets ohne format-args: konstante #()-strings, kein leeres widget beim pane-wechsel
S="$HOME/.config/tmux/plugins/tokyo-night-tmux/src"
W="$HOME/.config/tmux/scripts"
[ -d "$S" ] || exit 0
tmux set -g status-right "#($S/battery-widget.sh)#($W/active-path.sh)#($S/music-tmux-statusbar.sh)#($S/netspeed.sh)#($W/active-git.sh)$("$S"/datetime-widget.sh)"

# Plugin-Default ist 80 — zu knapp, sobald Kontextname oder zwei GitOps-Engines
# dazukommen; abgeschnitten wird ohne Vorwarnung
tmux set -g status-left-length 150

# Session-Pill: Plugin-Default ist grelles Vollblau (bg=#7aa2f7), passt nicht
# zum Rest der gedeckten Bar. Gleicher dunkler Hintergrund wie sketchybars
# BG_HIGHLIGHT, Text in Blau statt Block.
tmux set -g status-left "#[fg=#7aa2f7,bg=#143652,bold] #{?client_prefix,󰠠 ,#[dim]󰤂 }#[bold,nodim]#S #[default]   #(~/.config/tmux/scripts/kube.sh)    #(~/.config/tmux/scripts/gitops-health.sh)    #(~/.config/tmux/scripts/vpn.sh)   "
