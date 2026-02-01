Setting up a thermal throttle script for your Raspberry Pi is a smart move. It keeps your hardware safe while ensuring your Discord notifications don't turn into a "crying wolf" situation.

To do this, we’ll use a **bash script** that interacts with the Raspberry Pi’s frequency scaling governor and a **Discord Webhook**.

---

## 1. Prerequisites

First, ensure you have `cpufrequtils` installed to manage the CPU modes:

```bash
sudo apt-get update
sudo apt-get install cpufrequtils

```

Next, create a **Discord Webhook**:

1. Go to your Discord Server Settings > Integrations > Webhooks.
2. Create a "New Webhook," copy the **Webhook URL**, and keep it handy.

### 1. Updated Script (`thermal_monitor.sh`)

Replace your previous script content with this. I've added a `while true` loop and a `sleep` command to keep the process alive for PM2 to manage.

```bash
#!/bin/bash

# Configuration
THRESHOLD=70                 # Temp in Celsius to trigger slowdown
COOLDOWN=55                  # Temp to return to powersave
WEBHOOK_URL="YOUR_DISCORD_WEBHOOK_URL_HERE"

echo "Thermal Monitor Service Started..."

while true; do
    # Get current temperature
    TEMP=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
    TEMP_INT=${TEMP%.*}

    # Get current governor
    CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

    if [ "$TEMP_INT" -gt "$THRESHOLD" ] && [ "$CURRENT_GOV" != "powersave" ]; then
        # Action: Force Powersave
        echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
        
        MESSAGE="⚠️ **High Temp Alert!** Current Temp: ${TEMP}°C. CPU throttled to powersave."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" $WEBHOOK_URL
        echo "Alert sent: High temperature detected ($TEMP)"
        
    elif [ "$TEMP_INT" -lt "$COOLDOWN" ] && [ "$CURRENT_GOV" == "powersave" ]; then
        # Recovery: Back to normal powersave (or your preferred default)
        MESSAGE="✅ **Temp Stabilized.** Current Temp: ${TEMP}°C. System running cool."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" $WEBHOOK_URL
        echo "Alert sent: Temperature recovered ($TEMP)"
    fi

    # Wait 60 seconds before next check
    sleep 60
done

```

---

### 2. Launch with PM2

Run these commands to get the service running and ensure it survives a reboot:

1. **Start the script:**
`pm2 start thermal_monitor.sh --name "pi-thermal-guard"`
2. **Verify it's running:**
`pm2 list`
3. **Setup Startup Persistence:**
`pm2 startup`
*(Copy and paste the command it outputs to your terminal)*
4. **Save the state:**
`pm2 save`

---

### 3. Monitoring Tips

Since PM2 is now managing this, you can interact with your monitor using these commands:

* **View live logs:** `pm2 logs pi-thermal-guard` (Great for seeing the "Alert sent" messages).
* **Monitor resource usage:** `pm2 monit`
* **Stop the monitor:** `pm2 stop pi-thermal-guard`

