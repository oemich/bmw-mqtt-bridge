# BMW MQTT Bridge – Live Map Dashboard

This project demonstrates the bmw_mqtt_bridge and visualize vehicle positions in real time on an **OpenStreetMap map**.
The web interface is pure HTML + JavaScript (Leaflet + mqtt.js) and runs fully locally – no cloud, no webserver or login required.

---

## 🔧 Requirements

- your local MQTT broker
- bmw_mqtt_brigde up and running

---

### 1. Enable WebSocket listener (Port 9001)

On your PC running your Mosquitto Broker add another config file, for example
`/etc/mosquitto/conf.d/websockets.conf`

```conf
listener 9001
protocol websockets
allow_anonymous true
```

> 💡 Mosquitto can run multiple listeners in parallel.
> 1883 = standard MQTT, 9001 = WebSocket for browsers.

Restart Mosquitto:

```bash
sudo systemctl restart mosquitto
```

---

## 🗺️ Web Client (HTML Map)

The file [`bmwmap.html`](./bmwmap.html) visualizes vehicle positions in real time on an OpenStreetMap map.

### Preparation:

look for the line:
```
const brokerUrl = "ws://192.168.10.88:9001";
```
and enter the IP address of your Mosquitto MQTT Broker

### Features

- Real-time position updates via MQTT (WebSocket)
- Multiple vehicles supported
- Colored trails with position history
- Trails are stored persistently in `localStorage`
- Buttons to clear a single or all trails
- Runs fully standalone, just open the file bmwmap.html in your browser

---

## 🚀 Usage

1. Copy `bmwmap.html` to any of your PCs in the local network

2. Open bmwmap.html in your brower

(for viewing the html page from outside of your local network you will need a webserver)

---

## 🧑‍💻 Credits

- HTML/JS Map: @Kurt
- MQTT Integration & Docs: GPT-5 (OpenAI)
- Libraries: Leaflet, mqtt.js
- License: MIT

---
