#!/usr/bin/env bash
detail="/tmp/.tmux-gitops-unhealthy-detail"

echo "GitOps — nicht healthy/ready"
echo

if [ ! -s "$detail" ]; then
  echo "  Alles sauber ✓"
else
  column -t -s $'\t' "$detail" | sed 's/^/  /'
fi

echo
echo "Enter zum Schliessen..."
read -r
