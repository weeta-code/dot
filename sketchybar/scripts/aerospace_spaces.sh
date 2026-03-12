#!/bin/bash

FOCUSED=$(aerospace list-workspaces --focused)
WORKSPACES=$(aerospace list-workspaces --monitor all --empty no | sort | tr '\n' ' ')

# Build label: focused | others
OTHERS=""
for ws in $WORKSPACES; do
  [ "$ws" != "$FOCUSED" ] && OTHERS="$OTHERS$ws "
done

LABEL="$FOCUSED │ ${OTHERS% }"

sketchybar --set aerospace label="$LABEL"
