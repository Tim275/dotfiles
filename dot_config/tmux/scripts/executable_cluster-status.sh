#!/usr/bin/env bash
# Detail zum GitOps-Zaehler in der Statusbar (prefix + G)
W="$HOME/.config/tmux/scripts"
detail="/tmp/.tmux-gitops-unhealthy-detail"

"$W/gitops-health.sh" >/dev/null 2>&1

ctx=$(kubectl config current-context 2>/dev/null || echo "kein kubectl-Kontext")
echo "Cluster: $ctx"
echo
echo "ArgoCD Degraded/Missing/Unknown · Flux Ready=False"
echo
if [ -s "$detail" ]; then
  column -t -s $'\t' "$detail" | sed 's/^/  /'
else
  echo "  nichts kaputt"
fi

echo
echo "Enter zum Schliessen..."
read -r
