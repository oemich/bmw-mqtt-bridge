# 🆔 Get Your BMW IDs

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

At **CARDATA STREAM** don't forget to click `Change data selection` and activate the topics you want to receive.
