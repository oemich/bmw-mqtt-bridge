# 🚗 BMW CarData → MQTT Bridge

After BMW disabled access for *bimmerconnected*, an alternative solution was required.  
The best working replacement is the new **BMW CarData MQTT streaming interface**,  
which this bridge connects to and forwards to your local MQTT broker.

A small C++ bridge that connects **BMW ConnectedDrive CarData (MQTT)** to your **local Mosquitto MQTT broker**.  
It authenticates via the official BMW OAuth2 device flow and continuously republishes vehicle telemetry in real time.

---

## 🧩 Features

- MQTT v5 protocol with reason codes and reconnect logic  
- Automatic **token refresh** using BMW’s `refresh_token`  
- Local **watchdog & reconnect** if the BMW broker drops the connection  
- Publishes a small JSON status message (`bmw/status`) showing online/offline state  
- Lightweight: depends only on `libmosquitto`, `libcurl`, and `nlohmann/json` (header-only)  
- Runs perfectly on Debian, Ubuntu, or Raspberry Pi OS  

---

## 🧱 Project Structure

```
bmw-mqtt-bridge/
│
├── bmw_flow.sh          # Start OAuth2 device flow, get first tokens
├── bmw_refresh.sh       # Refresh id_token using refresh_token
├── bmw_mqtt_bridge.cpp  # Main bridge application (C++)
├── compile.sh           # Simple build script (g++)
├── install_deps.sh      # Installs required dependencies via apt
├── json.hpp             # nlohmann/json header (MIT license)
├── LICENSE              # MIT license
└── README.md            # This file
```

---

## ⚙️ Requirements

Tested on:
- Debian 12 / Ubuntu 22.04+ / Raspberry Pi OS Bookworm
- libmosquitto ≥ 2.0
- libcurl ≥ 7.74
- g++ ≥ 10

---

## 🧰 Installation

```bash
git clone https://github.com/<yourname>/bmw-mqtt-bridge.git
cd bmw-mqtt-bridge
chmod +x install_deps.sh
./install_deps.sh
```

This installs:
- `build-essential`
- `libmosquitto-dev`
- `libcurl4-openssl-dev`
- `jq`, `openssl`, `nlohmann-json3-dev`
- (optional) `mosquitto`, `mosquitto-clients`

---

## 🔍 Step 1: Get Your BMW Client ID

Before you can use this bridge, you need your **Client ID** and **GCID** from the BMW CarData portal.

1. Go to the **MyBMW** website for your country (URL differs per region).  
2. Log in with your existing BMW account (your car must already be registered).  
3. Navigate to **Vehicle Overview** → **BMW CarData**.  
4. Click **“Create Client Data”**.  (do NOT click "autheticate vehicle")
5. Copy the displayed **Client ID** — you will need it in:
   - `bmw_flow.sh`  
   - `bmw_refresh.sh`  
   - and inside `bmw_mqtt_bridge.cpp` (`CLIENT_ID` constant)
6. Activate **CarData Stream**.  
7. Scroll down to **CarData Streaming** → **Show Connection Details**.  
8. Copy the displayed **Username** — this is your **GCID**.  
   - Paste it into `bmw_mqtt_bridge.cpp` under the variable `GCID`.

Once both values are configured, you can proceed with authentication.

---

## 🔑 Step 2: Initial Token Setup

Run the **device flow script** to get your first tokens:

```bash
chmod +x bmw_flow.sh
./bmw_flow.sh
```

You’ll see output like:
```
1) Requesting device code…
2) Open this URL in your browser:
   https://customer.bmwgroup.com/...
```

Log in with your BMW account, confirm access, then the script saves:
```
access_token.txt
id_token.txt
refresh_token.txt
```

> The file **id_token.txt** is used as MQTT password.

---

## 🔁 Step 3: Token Refresh

To refresh tokens later (e.g. from a cron job or systemd service):

```bash
chmod +x bmw_refresh.sh
./bmw_refresh.sh
```

The bridge also calls this automatically when your token nears expiry.

---

## 🚀 Step 4: Build the Bridge

Compile manually or via the helper script:

```bash
chmod +x compile.sh
./compile.sh
```

Example manual build:
```bash
g++ -std=c++17 -O2 -pthread     bmw_mqtt_bridge.cpp -o bmw_mqtt_bridge     -lmosquitto -lcurl
```

---

## 🔌 Step 4: Run the Bridge

Run manually:
```bash
./bmw_mqtt_bridge
```

It will:
- Connect securely to BMW’s MQTT broker (`customer.streaming-cardata.bmwgroup.com:9000`)
- Mirror messages to your **local Mosquitto** at `127.0.0.1:1883`
- Republish under `bmw/<VIN>/...`

Status messages are published on:
```
bmw/status
```

Example payload:
```json
{
  "connected": true,
  "timestamp": 1759612345
}
```

---

## 🧠 How It Works

- `bmw_flow.sh` → gets your first OAuth2 tokens (manual login required)
- `bmw_refresh.sh` → uses the refresh_token to renew credentials
- `bmw_mqtt_bridge.cpp` → connects to the BMW MQTT broker using `id_token`
- The bridge automatically detects token expiry via JWT decoding (`exp` field)
- Before expiry, it runs `bmw_refresh.sh`, reloads tokens, and reconnects

---

## ⚡ Local MQTT Example

Subscribe to all BMW topics locally:
```bash
mosquitto_sub -h 127.0.0.1 -t 'bmw/#' -v
```

Or view just the status:
```bash
mosquitto_sub -h 127.0.0.1 -t 'bmw/status' -v
```

---

## 🔒 Security Notes

- BMW CarData is a private API — use responsibly.  
- Never publish or share your `id_token` / `refresh_token`.  
- Tokens expire automatically; the bridge refreshes them securely.  
- Keep your Mosquitto broker private or protected by authentication.  

---

## 🧾 License

MIT License  
Copyright (c) 2025 Kurt, DJ0ABR

This project also includes [`nlohmann/json`](https://github.com/nlohmann/json)  
licensed under the MIT License.

---

## ☕ Credits

Developed by **Kurt**  
Contributions, pull requests, and improvements are welcome!  
