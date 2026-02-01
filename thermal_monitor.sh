#!/bin/bash

# Configuration
#THRESHOLD=70                 # Temp in Celsius to trigger slowdown
THRESHOLD=60                 # Temp in Celsius to trigger slowdown
#COOLDOWN=55                  # Temp to return to powersave
COOLDOWN=50                  # Temp to return to powersave
WEBHOOK_URL="https://discord.com/api/webhooks/1467242216769716442/EyX5JUx8RJAwHqUyNYiSAKvDFl_y20zmelZlOdT402M-g9afe3_A91cDQHQXU3x_606M"

# State Flag: 0 = Normal (600-900MHz), 1 = Throttled (600MHz Lock)
# We start at 0 and force the initial state
STATE=0
sudo cpufreq-set -g ondemand -d 600M -u 1800M

echo "Thermal Monitor Started. Initial State: Normal (600-900MHz)"

while true; do
    TEMP=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
    TEMP_INT=${TEMP%.*}

    # TRIGGER THROTTLE: Temp > 70 and we are currently in Normal state
    if [ "$TEMP_INT" -gt "$THRESHOLD" ] && [ "$STATE" -eq 0 ]; then
        sudo cpufreq-set -g powersave -u 600M -d 600M
        STATE=1
        
        MESSAGE="🔥 **Critical Temp Alert:** ${TEMP}°C. CPU locked to 600MHz."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" $WEBHOOK_URL
        echo "$(date): Switched to THROTTLED state."

    # TRIGGER RECOVERY: Temp < 55 and we are currently in Throttled state
    elif [ "$TEMP_INT" -lt "$COOLDOWN" ] && [ "$STATE" -eq 1 ]; then
        sudo cpufreq-set -g ondemand -d 600M -u 900M
        STATE=0
        
        MESSAGE="✅ **Cooling Down:** ${TEMP}°C. CPU reset to 600-900MHz range."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" $WEBHOOK_URL
        echo "$(date): Switched to NORMAL state."
    fi

    sleep 60
done
