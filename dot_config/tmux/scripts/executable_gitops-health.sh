#!/usr/bin/env bash
# Erkennt selbst, ob der Cluster ArgoCD, Flux oder beides fährt, und zeigt je
# Engine einen eigenen Zähler:
#   gruen  argo 76      alle healthy
#   gelb   argo 76 ⟳2   2 laufen gerade (ArgoCD Progressing / Flux Ready=Unknown)
#   rot    argo 2/76    2 echt kaputt (ArgoCD Degraded|Missing|Unknown / Flux Ready=False)
# Bewusst pausiertes (ArgoCD Suspended, Flux spec.suspend) zaehlt nie als Fehler.
# Engine-Erkennung ueber den kubectl-Exitcode: fehlende CRD = Engine nicht da,
# vorhandene CRD mit 0 Objekten = still (nicht faelschlich "0" behaupten).
command -v kubectl &>/dev/null || exit 0

raw="/tmp/.tmux-gitops-raw"
cache="/tmp/.tmux-gitops"
mtime=$(stat -f %m "$cache" 2>/dev/null || stat -c %Y "$cache" 2>/dev/null || echo 0)
[ -f "$cache" ] && [ $(($(date +%s) - mtime)) -lt 15 ] && {
  cat "$cache"
  exit 0
}

count_bad() {
  awk -F'\t' '
    $2 == "ArgoCD" && ($3 == "Degraded" || $3 == "Missing" || $3 == "Unknown") { c++ }
    $2 != "ArgoCD" && $3 == "False" && $4 != "true" { c++ }
    END { print c + 0 }'
}
count_prog() {
  awk -F'\t' '
    $2 == "ArgoCD" && $3 == "Progressing" { c++ }
    $2 != "ArgoCD" && $3 == "Unknown" && $4 != "true" { c++ }
    END { print c + 0 }'
}
# nur ArgoCD: wartet auf manuellen Sync (Workloads sind bewusst nicht automated)
count_outofsync() {
  awk -F'\t' '$2 == "ArgoCD" && $4 == "OutOfSync" { c++ } END { print c + 0 }'
}

render() { # $1=label $2=daten
  local total bad prog oos
  total=$(printf '%s' "$2" | grep -c .)
  [ "$total" -eq 0 ] && return
  bad=$(printf '%s' "$2" | count_bad)
  oos=$(printf '%s' "$2" | count_outofsync)
  prog=$(printf '%s' "$2" | count_prog)
  if [ "$bad" -gt 0 ]; then
    printf ' #[fg=#f7768e]%s %s/%s#[default]' "$1" "$bad" "$total"
  elif [ "$oos" -gt 0 ]; then
    printf ' #[fg=#7dcfff]%s %s ⇅%s#[default]' "$1" "$total" "$oos"
  elif [ "$prog" -gt 0 ]; then
    printf ' #[fg=#e0af68]%s %s ⟳%s#[default]' "$1" "$total" "$prog"
  else
    printf ' #[fg=#9ece6a]%s %s#[default]' "$1" "$total"
  fi
}

# $(...) frisst den abschliessenden Zeilenumbruch — ohne das explizite \n beim
# Anhaengen verschmelzen letzte und erste Zeile zweier Abfragen zu einer.
argo=$(timeout 3 kubectl get applications.argoproj.io -A \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\tArgoCD\t"}{.status.health.status}{"\t"}{.status.sync.status}{"\n"}{end}' \
  2>/dev/null) || argo=""
[ -n "$argo" ] && argo="$argo"$'\n'

flux=""
for kind in kustomizations.kustomize.toolkit.fluxcd.io helmreleases.helm.toolkit.fluxcd.io; do
  if out=$(timeout 3 kubectl get "$kind" -A \
    -o jsonpath="{range .items[*]}{.metadata.namespace}{\"/\"}{.metadata.name}{\"\t${kind%%.*}\t\"}{range .status.conditions[?(@.type=='Ready')]}{.status}{end}{\"\t\"}{.spec.suspend}{\"\n\"}{end}" \
    2>/dev/null); then
    [ -n "$out" ] && flux="$flux$out"$'\n'
  fi
done

printf '%s%s' "$argo" "$flux" >"$raw"

body="$(render argo "$argo")$(render flux "$flux")"
if [ -n "$body" ]; then
  printf '%s%s' $'\U000F0995' "$body" >"$cache"
else
  : >"$cache"
fi
cat "$cache"
