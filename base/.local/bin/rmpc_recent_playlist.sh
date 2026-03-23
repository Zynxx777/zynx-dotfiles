#!/bin/bash
# Generate a "Recently Added" playlist for rmpc/mpd.
# It finds the most recently modified music files and saves them to a playlist.

MUSIC_DIR="/mnt/hdd_data1/Music"
PLAYLIST_DIR="$HOME/.config/mpd/playlists"
PLAYLIST_FILE="$PLAYLIST_DIR/Recently_Added.m3u"

mkdir -p "$PLAYLIST_DIR"

if [ ! -d "$MUSIC_DIR" ]; then
    echo "Music directory not found: $MUSIC_DIR"
    exit 1
fi

cd "$MUSIC_DIR" || exit 1

# List files with their modification times, sort by time (newest first), take top 200
find . -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.m4a" -o -iname "*.ogg" -o -iname "*.wav" -o -iname "*.aac" -o -iname "*.opus" -o -iname "*.wma" -o -iname "*.ape" -o -iname "*.wv" -o -iname "*.alac" -o -iname "*.mp4" \) -printf "%T@ %P\n" 2>/dev/null | \
  sort -rn | \
  head -n 200 | \
  cut -d' ' -f2- > "$PLAYLIST_FILE"

echo "Recently Added playlist updated at $PLAYLIST_FILE"

# Optional: Tell MPD to update
if command -v mpc &> /dev/null; then
  mpc update >/dev/null 2>&1
fi
