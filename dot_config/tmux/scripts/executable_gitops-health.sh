#!/usr/bin/env bash
command -v kubectl &>/dev/null || exit 0

cache="/tmp/.tmux-gitops-unhealthy"
detail="/tmp/.tmux-gitops-unhealthy-detail"
mtime=$(stat -f %m "$cache" 2>/dev/null || stat -c %Y "$cache" 2>/dev/null || echo 0)
if [ ! -f "$cache" ] || [ $(($(date +%s) - mtime)) -ge 15 ]; then
  {
    timeout 3 kubectl get applications -n argocd \
      -o jsonpath='{range .items[*]}{.metadata.name}{"\tArgoCD\t"}{.status.health.status}{"\n"}{end}' \
      2>/dev/null | awk -F'\t' '$3!="Healthy"'

    timeout 3 kubectl get kustomizations -A \
      -o jsonpath='{range .items[*]}{.metadata.name}{"\tFlux-Kustomization\t"}{range .status.conditions[?(@.type=="Ready")]}{.status}{end}{"\n"}{end}' \
      2>/dev/null | awk -F'\t' '$3!="True"'

    timeout 3 kubectl get helmreleases -A \
      -o jsonpath='{range .items[*]}{.metadata.name}{"\tFlux-HelmRelease\t"}{range .status.conditions[?(@.type=="Ready")]}{.status}{end}{"\n"}{end}' \
      2>/dev/null | awk -F'\t' '$3!="True"'
  } >"$detail"
  wc -l <"$detail" | tr -d ' ' >"$cache"
fi
count=$(cat "$cache" 2>/dev/null)

# leer wenn kein Zugriff oder alles healthy — health/ready-status statt sync-status,
# denn OutOfSync ist bei uns bewusst normal (manual-sync workloads)
[ -z "$count" ] && exit 0
[ "$count" = "0" ] && exit 0

echo "#[fg=#e0af68]󰦕 $count"
