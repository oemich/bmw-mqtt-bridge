# 🚗 BMW CarData → MQTT Bridge

<a href="https://dj0abr.github.io/bmw-mqtt-bridge/" target="_blank" rel="noopener">
  <img src="https://img.shields.io/badge/docs-online-brightgreen" alt="Docs" />
</a>
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

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

📘 **Full documentation:**  
➡️ https://dj0abr.github.io/bmw-mqtt-bridge/

---

## Quick start

```bash
git clone https://github.com/dj0abr/bmw-mqtt-bridge.git
cd bmw-mqtt-bridge
```

Choose one of the installation methods described in the documentation:

- [Classic installation](https://dj0abr.github.io/bmw-mqtt-bridge/install/)
- [Docker setup](https://dj0abr.github.io/bmw-mqtt-bridge/docker/)

---

## Usage

- [Environment variables (.env)](https://dj0abr.github.io/bmw-mqtt-bridge/env/)
- [MQTT topics](https://dj0abr.github.io/bmw-mqtt-bridge/mqtt/)
- [MQTT retain](https://dj0abr.github.io/bmw-mqtt-bridge/retain/)
- [System service (systemd)](https://dj0abr.github.io/bmw-mqtt-bridge/service/)

---

## License

MIT License © 2025 Kurt, DJ0ABR  
See [LICENSE](LICENSE) for details.