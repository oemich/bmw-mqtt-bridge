#!/bin/bash
# compile.sh – build bmw_mqtt_bridge inside src directory

# get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$ROOT_DIR/src"

cd "$SRC_DIR" || exit 1

echo "Compiling bmw_mqtt_bridge..."
g++ -std=c++17 -O2 -pthread \
  bmw_mqtt_bridge.cpp -o bmw_mqtt_bridge \
  $(pkg-config --cflags --libs libmosquitto) -lcurl

if [ $? -eq 0 ]; then
  echo "✅ Build successful: $SRC_DIR/bmw_mqtt_bridge"
else
  echo "❌ Build failed"
fi
