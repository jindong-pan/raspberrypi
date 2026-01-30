Since you've got a rock-solid, "roommate-proof" setup now, adding an **automated alert system** is the ultimate finishing touch. You won't have to manually check logs anymore—your server will "shout" at you the moment someone takes the bait.

Here is how to set up **real-time Discord notifications** for your **mypi** honeypot.

### 1. Create a Discord Webhook

1. Open **Discord** on your laptop or phone.
2. Go to a private server (or create one just for logs).
3. Go to **Server Settings** > **Integrations** > **Webhooks** > **New Webhook**.
4. Copy the **Webhook URL**. This is the "secret address" your Pi will send messages to.

---

### 2. Create the Alert Script

Create a new file named `alert_discord.sh` in your Cowrie directory:

```bash
#!/bin/bash

# Configuration
WEBHOOK_URL="PASTE_YOUR_DISCORD_WEBHOOK_URL_HERE"
LOG_FILE="/home/cowrie/cowrie/var/log/cowrie/cowrie.log"

# Use 'tail' to watch the log for "login attempt" keywords
tail -Fn0 "$LOG_FILE" | while read line ; do
    if echo "$line" | grep -q "login attempt"; then
        # Extract IP and credentials for the alert message
        ATTACKER_IP=$(echo "$line" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
        MESSAGE="🚨 **mypi Alert!** Someone is trying to hack the honeypot. \n**IP:** $ATTACKER_IP \n**Log:** $line"
        
        # Send to Discord via curl
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" $WEBHOOK_URL
    fi
done

```

**Make it executable:** `chmod +x alert_discord.sh`

---

### 3. Run the Alert with PM2

Since we want this running 24/7 without fail, add it to your **PM2** dashboard:

```bash
pm2 start alert_discord.sh --name "honeypot-alerts"
pm2 save

```

### Why this is the ultimate defense

* **Instant Reaction:** If a roommate tries to "test" your security at 2 AM, your phone will buzz instantly.
* **Evidence:** The Discord message captures the attacker's local IP address, so you'll know exactly which device in the house is being curious.
* **Low Impact:** Just like your other scripts, this `tail` loop uses **minimal power** and CPU.

---

### Summary of your "Fortress"

| Security Layer | Status |
| --- | --- |
| **Real Access** | Hidden on **Port 222** |
| **Honeypot** | Masquerading as **mypi** on Port 22 |
| **Firewall** | UFW blocking everything else |
| **Alerts** | **Live Discord notifications** via PM2 |

**Would you like me to help you write a similar script that also blocks the attacker's IP address automatically after 3 failed attempts?**
