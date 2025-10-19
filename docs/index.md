# 🚗 BMW CarData → MQTT Bridge

After BMW disabled access for *bimmerconnected*, an alternative solution was required.  
The best working replacement is the new **BMW CarData MQTT streaming interface**,  
which this bridge connects to and forwards to your local MQTT broker.

A small C++ bridge that connects **BMW ConnectedDrive CarData (MQTT)** to your **local Mosquitto MQTT broker**.  
It authenticates via the official BMW OAuth2 device flow and continuously republishes vehicle telemetry in real time.

You can run it **directly on Debian/Ubuntu/Raspberry Pi** or inside a **Docker container** – both options are fully supported.

---

## 🧩 Features

- MQTT v5 protocol with reason codes and reconnect logic  
- Automatic **token refresh** using BMW’s `refresh_token`  
- Local **watchdog & reconnect** if the BMW broker drops the connection  
- Publishes a small JSON status message (`bmw/status`) showing online/offline state  
- Lightweight: depends only on `libmosquitto`, `libcurl`, and `nlohmann/json` (header-only)  
- Runs perfectly on Debian, Ubuntu, or Raspberry Pi OS  
- **Docker support** with ready-to-use `docker-compose.yml`  

---

## 🧱 Project Structure

```
bmw-mqtt-bridge/
│
├── demo/                     # Example web client (map demo)
│   ├── bmwmap.html           # Simple HTML page showing vehicle on a map
│   └── README.md             # Instructions for demo usage
│
├── scripts/                  # Helper scripts and utilities
│   ├── bmw_flow.sh           # Start OAuth2 device flow and fetch first tokens
│   ├── compile.sh            # Simple build script (g++)
│   ├── docker-entrypoint.sh  # Entrypoint for Docker container
│   └── install_deps.sh       # Installs dependencies (libmosquitto, libcurl, etc.)
│
├── src/                      # Main C++ source files
│   ├── bmw_mqtt_bridge.cpp   # Core bridge logic (BMW ↔ MQTT)
│   └── json.hpp              # nlohmann/json header (MIT license)
│
├── .env.example              # Example environment configuration
├── docker-compose.yml        # Docker Compose setup
├── Dockerfile                # Docker image definition
├── LICENSE                   # MIT license
└── README.md                 # This file
```

## ⚙️ Requirements

Tested on:

- Debian 12 / Ubuntu 22.04+ / Raspberry Pi OS Bookworm
- libmosquitto ≥ 2.0
- libcurl ≥ 7.74
- g++ ≥ 10
- (optional) Docker ≥ 24 with Compose plugin

---