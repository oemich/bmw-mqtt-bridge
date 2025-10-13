#!/usr/bin/env bash
set -euo pipefail

STATE_BASE="${XDG_STATE_HOME:-/app/state}"
STATE_DIR="${STATE_BASE}/bmw-mqtt-bridge"
ID_FILE="${STATE_DIR}/id_token.txt"
RT_FILE="${STATE_DIR}/refresh_token.txt"

echo "[entrypoint] XDG_STATE_HOME=${STATE_BASE}"
echo "[entrypoint] Expecting tokens in: ${STATE_DIR}"

# Falls ein Befehl übergeben wurde (z.B. ./bmw_flow.sh, ls, bash …)
if [[ $# -gt 0 && "$1" != "/app/bmw_mqtt_bridge" ]]; then
  exec "$@"
fi

# Token-Check
if [[ ! -s "$ID_FILE" || ! -s "$RT_FILE" ]]; then
  echo "No token files found."
  echo "Please perform the initial authentication, e.g.:"
  echo "  docker compose run --rm -it bmw-bridge ./bmw_flow.sh"
  exit 1
fi

# Bridge starten
exec /app/bmw_mqtt_bridge
