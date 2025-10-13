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

---

## ⚙️ Requirements

Tested on:
- Debian 12 / Ubuntu 22.04+ / Raspberry Pi OS Bookworm
- libmosquitto ≥ 2.0
- libcurl ≥ 7.74
- g++ ≥ 10
- (optional) Docker ≥ 24 with Compose plugin

---

## ⚙️ Installation

You can install and run the bridge either **natively (bare metal)** or via **Docker**.

---

### 🧩 Option 1 – Classic Installation (without Docker)

For direct use on Debian, Ubuntu or Raspberry Pi OS.

```bash
# Clone the repository
git clone https://github.com/dj0abr/bmw-mqtt-bridge.git
cd bmw-mqtt-bridge

# Make scripts executable
chmod +x scripts/*.sh

# Install dependencies
./scripts/install_deps.sh

# Compile
./scripts/compile.sh

# Run OAuth2 Device Flow (creates .env automatically)
./scripts/bmw_flow.sh

If this is your first run, the script will:
- create ~/.local/state/bmw-mqtt-bridge/
- open nano with a new .env file
→ insert your CLIENT_ID and GCID there, then save and exit.

After that, open the displayed URL in your browser, log in,
then return and press ENTER.

# Then start the bridge:

./src/bmw_mqtt_bridge
```

---

### 🐳 Option 2 – Docker Installation

```bash
# Clone the repository and prepare the environment
git clone https://github.com/dj0abr/bmw-mqtt-bridge.git
cd bmw-mqtt-bridge

The bridge stores its .env file and all token files **on the host system** under
`~/.local/state/bmw-mqtt-bridge`.

The Docker container automatically links to this folder,
so host and container share the same configuration and tokens.
You can freely switch between **Docker** and the **classic bare-metal** version without re-authenticating.

# Build container
docker compose build --no-cache

# Authenticate with BMW (creates .env automatically)
docker compose run --rm -it bmw-bridge ./bmw_flow.sh

If this is your first run, it will create `~/.local/state/bmw-mqtt-bridge/.env`
and open the editor asking you to enter your CLIENT_ID and GCID before continuing.
After you’ve saved and closed the editor, run the above command again.

Open the displayed URL in your browser, log in,  
then return and press **ENTER**.

# Start bridge
docker compose up -d

# Logs
docker compose logs -f bmw-bridge
```

The bridge will now automatically stream BMW CarData to your local MQTT broker.

---

## 🆔 Get Your BMW IDs

Before you can use the bridge, you must retrieve your personal **BMW CarData identifiers**.

The script `scripts/bmw_flow.sh` automatically creates  
`~/.local/state/bmw-mqtt-bridge/.env` and guides you to fill in the IDs which
you get with the following procedure:

1. Go to the [MyBMW website](https://www.bmw-connecteddrive.com/)  
   (You should already have an account and your car must be registered.)
2. Navigate to **Personal Data → My Vehicles → CarData**  
3. Click on **"Create Client ID"**  
   ⚠️ *Do **not** click on "Authenticate Vehicle"!*
4. Copy the **Client ID** and insert it into the `.env` file
5. Scroll down to **CARDATA STREAM → Show Connection Details**
6. Copy the **USERNAME** and insert it into `.env` file as **GCID**
7. The other options in the `.env` file are for advanced setups – you can safely ignore them in most cases

After this setup, your bridge will be able to authenticate against the official BMW CarData MQTT interface.

8. at **CARDATA STREAM** don't forget the click `Change data selection` and activate the topics you want to receive

---

## 📝 Notes

- For direct usage, your MQTT broker (e.g., Mosquitto) must run locally on `127.0.0.1`.
- If you run the broker on another host, enter the IP into `.env` file.

---

## 🧰 Running as a System Service

You can install the bridge as a systemd service so that it starts automatically on boot.
Copy the sample service definition:

```bash
sudo cp service_example/bmw-mqtt-bridge.service /etc/systemd/system/
```

💡 **Important:**  
Edit the file `/etc/systemd/system/bmw-mqtt-bridge.service`  
```bash
sudo nano /etc/systemd/system/bmw-mqtt-bridge.service
```
and make sure that the lines
```
WorkingDirectory=/home/myUserName/bmw-mqtt-bridge
ExecStart=/home/myUserName/bmw-mqtt-bridge/src/bmw_mqtt_bridge
```
matches the username under which you normally run the bridge  


```bash
sudo systemctl daemon-reload
sudo systemctl enable bmw-mqtt-bridge.service
sudo systemctl start bmw-mqtt-bridge.service
```

The bridge stores its tokens in the user’s home directory  
(`~/.local/state/bmw-mqtt-bridge`), so this must point to the correct account.

Check the log output with:

```bash
journalctl -u bmw-mqtt-bridge -f
```

The service expects that you have already run  
`scripts/bmw_flow.sh` at least once to create  
`~/.local/state/bmw-mqtt-bridge/.env` and the token files.

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
Docker setup and project structure by **oemich**  
Uses the official BMW CARDATA STREAMING interface 

Contributions, pull requests, and improvements are welcome!
