#!/usr/bin/env bash
set -uo pipefail

rc=0
for f in .chezmoiscripts/*; do
  case "$f" in
    *.tmpl)
      out=$(mktemp)
      if chezmoi execute-template < "$f" > "$out"; then
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
