#!/bin/bash

MUSIC_DIR="$HOME/Music/Stash"
ART_CACHE_DIR="/tmp/sketchybar_art"
DEFAULT_ICON="󰎆"

# Ensure cache dir exists
mkdir -p "$ART_CACHE_DIR"

# Get mpc status
STATUS=$(mpc status 2>/dev/null)

if [[ -z "$STATUS" ]] || ! echo "$STATUS" | grep -q "\[playing\]\|\[paused\]"; then
    # Nothing playing - show idle state
    sketchybar --set music drawing=on \
                           label="Not Playing" \
                           icon="$DEFAULT_ICON" \
                           icon.background.image="" \
                           icon.background.drawing=off \
                           icon.color="0x60F25A16"
    exit 0
fi

# Get current song file
SONG_FILE=$(mpc current -f %file%)
FULL_PATH="$MUSIC_DIR/$SONG_FILE"

# Create unique cache filename based on song (forces sketchybar to reload)
SONG_HASH=$(echo "$SONG_FILE" | md5 | cut -c1-8)
ART_CACHE="$ART_CACHE_DIR/$SONG_HASH.jpg"

# Parse track info and status
TRACK=$(echo "$STATUS" | head -1)
STATE_LINE=$(echo "$STATUS" | grep -E "^\[")

# Clean track name
TRACK=$(echo "$TRACK" | sed 's/\.[^.]*$//; s/_[0-9]\+//g')

# Extract time
TIME=$(echo "$STATE_LINE" | grep -oE "[0-9]+:[0-9]+/[0-9]+:[0-9]+" | sed 's/\// \/ /')

# Check if paused
if echo "$STATE_LINE" | grep -q "\[paused\]"; then
    ICON_COLOR="0x80F25A16"
else
    ICON_COLOR="0xFFF25A16"
fi

LABEL="$TRACK  $TIME"

# Try to extract album art (skip if already cached)
ART_EXTRACTED=false
if [[ -f "$ART_CACHE" && -s "$ART_CACHE" ]]; then
    ART_EXTRACTED=true
elif [[ -f "$FULL_PATH" ]]; then
    # Clean old cache files (keep last 20)
    ls -t "$ART_CACHE_DIR"/*.jpg 2>/dev/null | tail -n +21 | xargs rm -f 2>/dev/null
    
    # Extract embedded art and normalize to 500x500 (works for mp3, m4a, flac)
    ffmpeg -y -i "$FULL_PATH" -an -vf "scale=500:500:force_original_aspect_ratio=decrease,pad=500:500:(ow-iw)/2:(oh-ih)/2" "$ART_CACHE" 2>/dev/null
    if [[ -f "$ART_CACHE" && -s "$ART_CACHE" ]]; then
        ART_EXTRACTED=true
    fi
fi

# Update sketchybar
if $ART_EXTRACTED; then
    sketchybar --set music drawing=on \
                           label="$LABEL" \
                           icon="" \
                           icon.background.image="$ART_CACHE" \
                           icon.background.drawing=on \
                           icon.background.image.scale=0.034 \
                           icon.background.image.padding_left=6 \
                           icon.background.image.padding_right=6 \
                           icon.padding_left=12 \
                           icon.padding_right=8
else
    sketchybar --set music drawing=on \
                           label="$LABEL" \
                           icon="$DEFAULT_ICON" \
                           icon.background.image="" \
                           icon.background.drawing=off \
                           icon.color="$ICON_COLOR"
fi
