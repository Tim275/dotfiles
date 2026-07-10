#!/usr/bin/env bash
command -v kubectl &>/dev/null || exit 0
ctx=$(kubectl config current-context 2>/dev/null)
[ -z "$ctx" ] && exit 0

safe=0
case "$ctx" in
  *talos*) short="talos" ;;
  *k3s*) short="k3s" ;;
  *minikube* | *kind* | *docker-desktop*) short="local"; safe=1 ;;
  admin@*) short="${ctx#admin@}" ;;
  arn:aws:eks:*) short="${ctx##*/}" ;;
  *) short="$ctx" ;;
esac
[ ${#short} -gt 14 ] && short="${short:0:12}.."

ns=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null)
[ -z "$ns" ] && ns="default"

cache="/tmp/.tmux-kube-nodes"
mtime=$(stat -f %m "$cache" 2>/dev/null || stat -c %Y "$cache" 2>/dev/null || echo 0)
if [ ! -f "$cache" ] || [ $(($(date +%s) - mtime)) -ge 10 ]; then
  out=$(timeout 2 kubectl get nodes --no-headers 2>/dev/null)
  if [ -n "$out" ]; then
    total=$(echo "$out" | wc -l | tr -d ' ')
    ready=$(echo "$out" | awk '$2=="Ready"' | wc -l | tr -d ' ')
    echo "${ready}/${total}" >"$cache"
  else
    : >"$cache"
  fi
fi
nodes=$(cat "$cache" 2>/dev/null)

text="☸ $short:$ns"
[ -n "$nodes" ] && text="$text $nodes"

if [ "$safe" = "1" ]; then
  echo "#[fg=green]$text#[default]"
else
  echo "$text"
fi
