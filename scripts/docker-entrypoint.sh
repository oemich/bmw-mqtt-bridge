#!/usr/bin/env bash
set -euo pipefail

# Token directory (from ENV or default)
OUT_DIR="${OUT_DIR:-/app/tokens}"

# Ensure it exists
mkdir -p "$OUT_DIR"

# If token files exist, create/update symlinks
if [ -f "$OUT_DIR/id_token.txt" ]; then
  ln -sf "$OUT_DIR/id_token.txt" /app/id_token.txt
fi
if [ -f "$OUT_DIR/refresh_token.txt" ]; then
  ln -sf "$OUT_DIR/refresh_token.txt" /app/refresh_token.txt
fi

# If a command was passed -> execute it directly
if [ "$#" -gt 0 ]; then
  exec "$@"
fi

# Check if initial authentication is necessary
if [ ! -f /app/id_token.txt ] || [ ! -f /app/refresh_token.txt ]; then
  echo "No token files found."
  echo "Please perform the initial authentication, e.g.:"
  echo "  docker compose run --rm bmw-bridge ./bmw_flow.sh"
  exit 1
fi

# Start the bridge (handles refresh itself now)
exec ./bmw_mqtt_bridge
