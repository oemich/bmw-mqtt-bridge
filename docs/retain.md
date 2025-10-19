# 🔁 MQTT Retain (optional)

To ensure Home Assistant and other clients immediately see the last known state after a restart, the bridge can publish its republished MQTT messages **with the Retain flag**.

**Default:** off (`MQTT_RETAIN=0`)  
**When enabled:** Retain applies to:
- `bmw/raw/<VIN>/<eventName>`
- `bmw/<VIN>/<eventName>` (Legacy)
- `bmw/vehicles/<VIN>/<propertyName>` (when `SPLIT_TOPICS=1`)

The **status topic** `bmw/status` is always retained (LWT), regardless of this setting, to keep availability tracking consistent.

### Enable

edit the file: **.env**
```ini
MQTT_RETAIN=1
```

### Clean up (remove retained messages)

If you want to clear a topic:

```bash
# remove retained message (send empty retained message)
mosquitto_pub -t 'bmw/vehicles/<VIN>/range_km' -r -n
```

or, alternatively, use MQTT Explorer

### Notes

- For **stateful topics** (e.g. door lock, availability, battery values) retain is very useful.  
- For **high-frequency or transient** topics, retain may be undesirable (it shows an outdated snapshot).  
- If you later change your `LOCAL_PREFIX`, old retained messages under the previous prefix will remain in your broker until you remove them manually (see above).
