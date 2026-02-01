#!/bin/bash

# Configuration
THRESHOLD=70
COOLDOWN=55
WEBHOOK_URL="https://discord.com/api/webhooks/1467242216769716442/EyX5JUx8RJAwHqUyNYiSAKvDFl_y20zmelZlOdT402M-g9afe3_A91cDQHQXU3x_606M"
CONFIG_FILE="/home/jeremy/thermal.conf"

# Internal memory
LAST_THRESHOLD=$THRESHOLD
LAST_COOLDOWN=$COOLDOWN

update_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        
        if [ "$THRESHOLD" != "$LAST_THRESHOLD" ] || [ "$COOLDOWN" != "$LAST_COOLDOWN" ]; then
            MODIFIER=$(stat -c '%U' "$CONFIG_FILE")
            MSG="⚙️ **Config Updated by $MODIFIER:** Threshold: ${THRESHOLD}°C, Cooldown: ${COOLDOWN}°C"
            curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MSG\"}" "$WEBHOOK_URL"
            
            LAST_THRESHOLD=$THRESHOLD
            LAST_COOLDOWN=$COOLDOWN
        fi
    fi
}

# --- REBOOT / STARTUP ALERT ---
# Determine initial state upon startup
TEMP=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
TEMP_INT=${TEMP%.*}

if [ "$TEMP_INT" -gt "$THRESHOLD" ]; then
    INIT_STATUS="🚨 HIGH (Throttled to 600MHz)"
    sudo cpufreq-set -g powersave -u 600M -d 600M
else
    INIT_STATUS="✅ NORMAL (Set to 660-990MHz)"
    sudo cpufreq-set -g ondemand -d 660M -u 990M
fi

REBOOT_MSG="🚀 **System Online:** Pi Thermal Guard has started. Initial Temp: ${TEMP}°C. Status: $INIT_STATUS"
curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$REBOOT_MSG\"}" "$WEBHOOK_URL"
# ------------------------------

while true; do
    update_config
    
    TEMP=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
    TEMP_INT=${TEMP%.*}
    CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    CUR_HZ=$(vcgencmd measure_clock arm | awk -F'=' '{print $2}')
    CUR_MHZ=$((CUR_HZ / 1000000))

    if [ "$TEMP_INT" -gt "$THRESHOLD" ]; then
        if [ "$CURRENT_GOV" != "powersave" ] || [ "$CUR_MHZ" -gt 610 ]; then
            sudo cpufreq-set -g powersave -u 600M -d 600M
            MESSAGE="🚨 **Thermal Action:** Temp: ${TEMP}°C. Hardware at ${CUR_MHZ}MHz. Forcing 600MHz lock."
            curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" "$WEBHOOK_URL"
        fi
    elif [ "$TEMP_INT" -lt "$COOLDOWN" ]; then
        if [ "$CURRENT_GOV" == "powersave" ] || [ "$CUR_MHZ" -lt 700 ]; then
            sudo cpufreq-set -g ondemand -d 660M -u 990M
            MESSAGE="✅ **Thermal Recovery:** Temp: ${TEMP}°C. Restoring 660-990MHz range."
            curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" "$WEBHOOK_URL"
        fi
    fi
    sleep 60
done
