# 🧰 Running as a System Service

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
User=myUserName
WorkingDirectory=/home/myUserName/bmw-mqtt-bridge
ExecStart=/home/myUserName/bmw-mqtt-bridge/src/bmw_mqtt_bridge
```

match the username under which you normally run the bridge  

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
