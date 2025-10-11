# Build stage
FROM debian:bookworm-slim AS builder

# Install build dependencies
# Note: libmosquitto-dev and libcurl4-openssl-dev are needed for compilation.
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    libmosquitto-dev \
    libcurl4-openssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Keep a stable working directory
WORKDIR /build

# Copy the source and scripts directories as-is to preserve structure.
# compile.sh expects ROOT_DIR/src relative to its own path.
COPY ./src ./src
COPY ./scripts ./scripts

# Build the binary using the provided script.
# The script compiles inside /build/src and outputs /build/src/bmw_mqtt_bridge.
RUN chmod +x ./scripts/compile.sh && bash ./scripts/compile.sh

# -----------------------------------------------------------------------------

# Runtime stage
FROM debian:bookworm-slim

# Install runtime dependencies only (keep image lean)
RUN apt-get update && apt-get install -y \
    libmosquitto1 \
    libcurl4 \
    ca-certificates \
    bash \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Application directory
WORKDIR /app

# Copy the compiled binary from the builder stage
# Note: compile.sh places the binary under /build/src/bmw_mqtt_bridge
COPY --from=builder /build/src/bmw_mqtt_bridge /app/bmw_mqtt_bridge

# Copy runtime scripts (no bmw_refresh.sh anymore)
COPY ./scripts/bmw_flow.sh .
COPY ./scripts/docker-entrypoint.sh .

# Make binaries/scripts executable
RUN chmod +x /app/bmw_mqtt_bridge /app/bmw_flow.sh /app/docker-entrypoint.sh || true

# Configuration via environment variables
# LOCAL_HOST: consider using the Docker service name of your MQTT broker (e.g. "mqtt")
# instead of a loopback address.
ENV BMW_HOST="customer.streaming-cardata.bmwgroup.com" \
    BMW_PORT=9000 \
    LOCAL_HOST="127.0.1" \
    LOCAL_PORT=1883 \
    LOCAL_PREFIX="bmw/" \
    OUT_DIR="/app/tokens"

# Persist token directory across container restarts
VOLUME ["/app/tokens"]

# Entry point
# docker-entrypoint.sh no longer calls bmw_refresh.sh; the binary handles refresh itself.
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
CMD ["./docker-entrypoint.sh"]
