#!/usr/bin/env bash
# ArgoCD + Flux: nur echte Fehlzustaende. Voll qualifizierte CRD-Namen, damit ein
# fehlender Operator sauber ins Leere laeuft statt zufaellig was anderes zu treffen.
#
# Bewusst NICHT gezaehlt:
#   ArgoCD Progressing / Flux Ready=Unknown -> laufender Rollout, transient
#   ArgoCD Suspended    / Flux spec.suspend -> bewusst pausiert
command -v kubectl &>/dev/null || exit 0

cache="/tmp/.tmux-gitops-unhealthy"
detail="/tmp/.tmux-gitops-unhealthy-detail"
mtime=$(stat -f %m "$cache" 2>/dev/null || stat -c %Y "$cache" 2>/dev/null || echo 0)
if [ ! -f "$cache" ] || [ $(($(date +%s) - mtime)) -ge 15 ]; then
  {
    timeout 3 kubectl get applications.argoproj.io -A \
      -o jsonpath='{range .items[*]}{.metadata.name}{"\tArgoCD\t"}{.status.health.status}{"\n"}{end}' \
      2>/dev/null |
      awk -F'\t' '$3 == "Degraded" || $3 == "Missing" || $3 == "Unknown"'

    for kind in kustomizations.kustomize.toolkit.fluxcd.io helmreleases.helm.toolkit.fluxcd.io; do
      timeout 3 kubectl get "$kind" -A \
        -o jsonpath="{range .items[*]}{.metadata.namespace}{\"/\"}{.metadata.name}{\"\t${kind%%.*}\t\"}{range .status.conditions[?(@.type=='Ready')]}{.status}{end}{\"\t\"}{.spec.suspend}{\"\n\"}{end}" \
        2>/dev/null |
        awk -F'\t' '$3 == "False" && $4 != "true" { print $1"\t"$2"\t"$3 }'
    done
  } >"$detail"
  wc -l <"$detail" | tr -d ' ' >"$cache"
fi
count=$(cat "$cache" 2>/dev/null)

[ -z "$count" ] && exit 0
[ "$count" = "0" ] && exit 0

echo "#[fg=#e0af68]󰦕 $count#[default]"
