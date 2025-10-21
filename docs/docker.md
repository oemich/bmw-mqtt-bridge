# 🐳 Option 2 – Docker Installation

```bash
# Clone the repository and prepare the environment
git clone https://github.com/dj0abr/bmw-mqtt-bridge.git
cd bmw-mqtt-bridge
```

The bridge stores its .env file and all token files **on the host system** under  
`~/.local/state/bmw-mqtt-bridge`.

The Docker container automatically links to this folder,  
so host and container share the same configuration and tokens.  
You can freely switch between **Docker** and the **classic bare-metal** version without re-authenticating.

```bash
# Authenticate with BMW (creates .env automatically)
docker compose run --rm -it bmw-bridge ./bmw_flow.sh
```

If this is your first run, it will create `~/.local/state/bmw-mqtt-bridge/.env`  
and open the editor asking you to enter your CLIENT_ID and GCID (and other environment variables, if required) before continuing.  
After you’ve saved and closed the editor, run the above command again.

Open the displayed URL in your browser, log in, then return and press **ENTER**.

```bash
# Start bridge
docker compose up -d

# Logs
docker compose logs -f bmw-bridge
```

The bridge will now automatically stream BMW CarData to your local MQTT broker.

## Build and run your own Docker image

If you want to build the docker image yourself (e.g. to use the latest source code), run:

```bash
# Build the Docker image with a custom tag
docker build -t bmw-mqtt-bridge:custom .

# Authenticate with BMW (creates .env automatically)
docker run -it --rm \
    -v ~/.local/state/bmw-mqtt-bridge:/app/state \
    -e TZ=Europe/Berlin \
    bmw-mqtt-bridge:custom ./bmw_flow.sh

# Start the bridge in detached mode
docker run -d \
    --name bmw-bridge \
    -e XDG_STATE_HOME=/app/state \
    -e LOCAL_HOST=host.docker.internal \
    -e LOCAL_PORT=1883 \
    -e LOCAL_PREFIX=bmw/ \
    -v ~/.local/state/bmw-mqtt-bridge:/app/state/bmw-mqtt \
    bmw-mqtt-bridge:custom \
    --restart unless-stopped
```
