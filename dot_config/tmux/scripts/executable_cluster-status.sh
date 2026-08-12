#!/usr/bin/env bash
# Detail zum GitOps-Zaehler in der Statusbar (prefix + G)
W="$HOME/.config/tmux/scripts"
raw="/tmp/.tmux-gitops-raw"

"$W/gitops-health.sh" >/dev/null 2>&1

ctx=$(kubectl config current-context 2>/dev/null || echo "kein kubectl-Kontext")
total=$(grep -c . "$raw" 2>/dev/null || echo 0)
echo "Cluster: $ctx   ($total von ArgoCD/Flux verwaltet)"
echo

if [ "$total" -eq 0 ]; then
  echo "  kein ArgoCD/Flux erreichbar"
else
  auffaellig=$(awk -F'\t' '
    $2 == "ArgoCD" && $3 != "Healthy" { print $1"\t"$2"\t"$3 }
    $2 != "ArgoCD" && $3 != "True" && $4 != "true" { print $1"\t"$2"\t"$3 }' "$raw")
  if [ -n "$auffaellig" ]; then
    printf '%s\n' "$auffaellig" | column -t -s $'\t' | sed 's/^/  /'
  else
    echo "  alles healthy"
  fi
fi

echo
echo "Enter zum Schliessen..."
read -r
