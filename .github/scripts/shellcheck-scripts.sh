#!/usr/bin/env bash
set -uo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

rc=0
for f in "$root"/.chezmoiscripts/*; do
  case "$f" in
    *.tmpl)
      out=$(mktemp)
      # --source explizit: ohne das loest {{ include }} gegen das echte
      # Source-Dir des Users auf, das im CI-Runner nicht existiert
      if chezmoi execute-template --source "$root" <"$f" >"$out"; then
        shellcheck -s bash "$out" || rc=1
      else
        echo "template rendert nicht: $f" >&2
        rc=1
      fi
      rm -f "$out"
      ;;
    *)
      shellcheck "$f" || rc=1
      ;;
  esac
done
exit "$rc"
