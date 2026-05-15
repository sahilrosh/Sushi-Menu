#!/usr/bin/env bash
# Regenerate README demo GIF after updating Assets/screen_recording.mp4
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MP4="$ROOT/Assets/screen_recording.mp4"
GIF="$ROOT/Assets/screen_recording.gif"

if [[ ! -f "$MP4" ]]; then
  echo "Missing: $MP4"
  exit 1
fi

ffmpeg -y -i "$MP4" \
  -vf "fps=10,scale=300:-1:flags=lanczos,split[s0][s1];[s0]palettegen=stats_mode=diff[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5" \
  -loop 0 "$GIF"

echo "Wrote $GIF ($(du -h "$GIF" | cut -f1))"
echo "Next: bump ?v= in README Demo img src, then commit Assets/screen_recording.mp4 Assets/screen_recording.gif README.md"
