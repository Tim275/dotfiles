#!/bin/bash
# Show current Kubernetes context
CONTEXT=$(kubectl config current-context 2>/dev/null | cut -d'/' -f2 | cut -d':' -f1 || echo "none")
if [ "$CONTEXT" = "none" ] || [ -z "$CONTEXT" ]; then
  sketchybar --set $NAME label="N/A"
else
  # Shorten long context names
  SHORT=$(echo "$CONTEXT" | cut -c1-12)
  sketchybar --set $NAME label="$SHORT"
fi
