#!/bin/bash

# Get mpc status
STATUS=$(mpc status 2>/dev/null)

if [[ -z "$STATUS" ]] || ! echo "$STATUS" | grep -q "\[playing\]\|\[paused\]"; then
    # Nothing playing - hide widget
    sketchybar --set music.info drawing=off \
               --set music.time drawing=off
    exit 0
fi

# Parse track info (line 1) and status (line 2)
TRACK=$(echo "$STATUS" | head -1)
STATE_LINE=$(echo "$STATUS" | grep -E "^\[")

# Clean track name: remove .mp3/.flac, remove _digits patterns
TRACK=$(echo "$TRACK" | sed 's/\.[^.]*$//; s/_[0-9]\+//g')

# Extract time: "0:46/3:23" -> "0:46 / 3:23"
TIME=$(echo "$STATE_LINE" | grep -oE "[0-9]+:[0-9]+/[0-9]+:[0-9]+" | sed 's/\// \/ /')

# Check if paused
if echo "$STATE_LINE" | grep -q "\[paused\]"; then
    ICON_COLOR="0x80F25A16"  # Dimmed orange
else
    ICON_COLOR="0xFFF25A16"  # Full orange
fi

# Update sketchybar
sketchybar --set music.info drawing=on \
                            label="$TRACK" \
                            icon.color="$ICON_COLOR" \
           --set music.time drawing=on \
                            label="$TIME"
