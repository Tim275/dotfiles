#!/usr/bin/env bash
command -v kubectl &>/dev/null || exit 0

cache="/tmp/.tmux-argocd-unhealthy"
mtime=$(stat -f %m "$cache" 2>/dev/null || stat -c %Y "$cache" 2>/dev/null || echo 0)
if [ ! -f "$cache" ] || [ $(($(date +%s) - mtime)) -ge 15 ]; then
  count=$(timeout 3 kubectl get applications -n argocd \
    -o jsonpath='{range .items[*]}{.status.health.status}{"\n"}{end}' 2>/dev/null |
    grep -vc '^Healthy$')
  echo "$count" >"$cache"
fi
count=$(cat "$cache" 2>/dev/null)

# leer wenn kein Zugriff oder alles healthy — health.status statt sync.status,
# denn OutOfSync ist bei uns bewusst normal (manual-sync workloads)
[ -z "$count" ] && exit 0
[ "$count" = "0" ] && exit 0

echo "#[fg=#e0af68]󰦕 $count"
