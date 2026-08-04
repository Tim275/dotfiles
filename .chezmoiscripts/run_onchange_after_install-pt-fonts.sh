#!/bin/bash
# Ersetzt die Casks font-pt-{sans,serif,mono} — deren Download bei paratype.com
# gibt 401 und reisst die ganze brew-bundle-Downloadphase mit.
set -eu

[ "$(uname -s)" = "Darwin" ] || exit 0

dest="$HOME/Library/Fonts"
base="https://raw.githubusercontent.com/google/fonts/main/ofl"

fonts="
ptsans/PT_Sans-Web-Regular.ttf
ptsans/PT_Sans-Web-Bold.ttf
ptsans/PT_Sans-Web-Italic.ttf
ptsans/PT_Sans-Web-BoldItalic.ttf
ptsansnarrow/PT_Sans-Narrow-Web-Regular.ttf
ptsansnarrow/PT_Sans-Narrow-Web-Bold.ttf
ptsanscaption/PT_Sans-Caption-Web-Regular.ttf
ptsanscaption/PT_Sans-Caption-Web-Bold.ttf
ptserif/PT_Serif-Web-Regular.ttf
ptserif/PT_Serif-Web-Bold.ttf
ptserif/PT_Serif-Web-Italic.ttf
ptserif/PT_Serif-Web-BoldItalic.ttf
ptserifcaption/PT_Serif-Caption-Web-Regular.ttf
ptserifcaption/PT_Serif-Caption-Web-Italic.ttf
ptmono/PTM55FT.ttf
"

mkdir -p "$dest"

for f in $fonts; do
  name="${f##*/}"
  [ -f "$dest/$name" ] && continue
  tmp="$(mktemp)"
  if curl -fsSL "$base/$f" -o "$tmp"; then
    mv "$tmp" "$dest/$name"
  else
    rm -f "$tmp"
    echo "PT-Fonts: $name fehlgeschlagen" >&2
  fi
done
