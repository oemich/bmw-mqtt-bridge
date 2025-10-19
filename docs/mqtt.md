# 🌐 MQTT Topics and Environment Variables

### Status Topic Prefix

By default, the bridge publishes its connection status to:

```
bmw/status
bmw/status_stable
```

If you want a different topic prefix (for example if you have multiple cars or bridges),  
you can configure it using this environment variable in your .env file:

```
LOCAL_PREFIX=mycar/
```

The bridge will then publish:

```
mycar/status
mycar/status_stable
```

and all other MQTT messages (e.g. `raw`, `vehicles`, etc.) under the same prefix.

**status:**

Indicates the current connection state to the BMW MQTT broker (true = connected, false = disconnected).

**status_stable:**

Same as status, but the transition from true to false is delayed by 5 seconds (the delay can be configured in seconds via the environment variable STATUS_STABLE_DELAY).
This prevents short disconnects — for example during token refresh — from causing flickering in clients that monitor connection status.

---

### Split Topics (Structured JSON Publishing)

By default, the bridge republishes BMW CarData messages exactly as received  
into a local topic of the form:

```
bmw/raw/<VIN>/<eventName>
```

To make integration easier for automation systems (like Home Assistant, Node-RED, etc.),  
you can optionally enable **split topics**, which publish each data field under its own sub-topic:

add to your `.env` file:

```
SPLIT_TOPICS=1
```

This will create additional messages like:

```
bmw/vehicles/<VIN>/fuelPercentage {"value":62.5,"unit":"%","timestamp":1739790000}
bmw/vehicles/<VIN>/range_km       {"value":420}
bmw/vehicles/<VIN>/position       {"value":{"lat":48.1,"lon":11.6},"timestamp":1739790100}
```
