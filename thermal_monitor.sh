#!/bin/bash

# Configuration
THRESHOLD=70
COOLDOWN=55
WEBHOOK_URL="https://discord.com/api/webhooks/1467242216769716442/EyX5JUx8RJAwHqUyNYiSAKvDFl_y20zmelZlOdT402M-g9afe3_A91cDQHQXU3x_606M"
CONFIG_FILE="/home/jeremy/thermal.conf"

# Internal memory to track config changes
LAST_THRESHOLD=$THRESHOLD
LAST_COOLDOWN=$COOLDOWN

# Function to read config and alert on changes
update_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        
        # Check if values changed since last loop
        if [ "$THRESHOLD" != "$LAST_THRESHOLD" ] || [ "$COOLDOWN" != "$LAST_COOLDOWN" ]; then
            MSG="⚙️ **Config Updated:** New Threshold: ${THRESHOLD}°C, New Cooldown: ${COOLDOWN}°C (Was: ${LAST_THRESHOLD}/${LAST_COOLDOWN})"
            curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MSG\"}" "$WEBHOOK_URL"
            
            # Update memory
            LAST_THRESHOLD=$THRESHOLD
            LAST_COOLDOWN=$COOLDOWN
            echo "$(date): Configuration change detected and alerted."
        fi
    fi
}

echo "Thermal Monitor Service (v2) Started..."

while true; do
    update_config
    
    # 1. Gather hardware reality
    TEMP=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
    TEMP_INT=${TEMP%.*}
    CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    
    CUR_HZ=$(vcgencmd measure_clock arm | awk -F'=' '{print $2}')
    CUR_MHZ=$((CUR_HZ / 1000000))

    # 2. CASE: HIGH TEMP + NEEDS THROTTLE (OR MANUAL OVERRIDE)
    if [ "$TEMP_INT" -gt "$THRESHOLD" ]; then
        if [ "$CURRENT_GOV" != "powersave" ] || [ "$CUR_MHZ" -gt 610 ]; then
            sudo cpufreq-set -g powersave -u 600M -d 600M
            
            MESSAGE="🚨 **Thermal Action:** Temp: ${TEMP}°C. Hardware at ${CUR_MHZ}MHz. Forcing 600MHz lock."
            curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" "$WEBHOOK_URL"
        fi

    # 3. CASE: COOL TEMP + NEEDS RECOVERY
    elif [ "$TEMP_INT" -lt "$COOLDOWN" ]; then
        if [ "$CURRENT_GOV" == "powersave" ] || [ "$CUR_MHZ" -lt 700 ]; then
            sudo cpufreq-set -g ondemand -d 600M -u 900M
            
            MESSAGE="✅ **Thermal Recovery:** Temp: ${TEMP}°C. Restoring 600-900MHz range."
            curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" "$WEBHOOK_URL"
        fi
    fi

    sleep 60
done
