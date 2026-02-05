That is a brilliant "Cyber Lab" project. You are essentially turning your server into a **Honeypot**. By keeping `PasswordAuthentication yes` but guarding it with `Fail2Ban`, you’re inviting attackers to try the door just so you can catch them.

Using a **Discord Webhook** is the perfect way to get real-time alerts on your phone whenever someone (or something) tries to mess with your server.

---

### Step 1: Create your Discord Webhook

1. Open Discord and go to your **Server Settings**.
2. Go to **Integrations** > **Webhooks** > **New Webhook**.
3. Name it "Server Sentry" and copy the **Webhook URL**. (Keep this private!)

---

### Step 2: Create the Alert Script

On your **.132 server**, create a script that will send the message to Discord.

```bash
sudo nano /usr/local/bin/discord_alert.sh

```YOUR_WEBHOOK_URL

Paste this code (replace `YOUR_WEBHOOK_URL` with your actual link):

```bash
#!/bin/bash
# Discord Webhook Alert Script

WEBHOOK_URL="YOUR_WEBHOOK_URL"
HOSTNAME=$(hostname)
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# The message is passed as an argument to the script
MESSAGE="$1"

PAYLOAD="{\"content\": \"🚨 **Security Alert from $HOSTNAME ($IP_ADDRESS)** 🚨\n$MESSAGE\"}"

curl -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$WEBHOOK_URL"

```

**Make it executable:**

```bash
sudo chmod +x /usr/local/bin/discord_alert.sh

```

---

### Step 3: Connect Fail2Ban to Discord

Now we tell Fail2Ban to run this script whenever it bans an IP.

1. **Create a new action file:**
```bash
sudo nano /etc/fail2ban/action.d/discord-alert.conf

```


2. **Add this configuration:**
```ini
[Definition]
# When Fail2Ban starts
actionstart = /usr/local/bin/discord_alert.sh "Fail2Ban has started guarding our SSH door."

# When an IP is banned
actionban = /usr/local/bin/discord_alert.sh "Banned IP: <ip> after <failures> failed attempts on jail <name>."

# When an IP is unbanned (optional)
actionunban = /usr/local/bin/discord_alert.sh "Unbanned IP: <ip>. They can try their luck again."

```


3. **Apply it to your SSH Jail:**
Edit your local jail config: `sudo nano /etc/fail2ban/jail.local`
Find your `[sshd]` section and add the `action`:
```ini
[sshd]
enabled = true
port    = ssh
filter  = sshd
logpath = /var/log/auth.log
maxretry = 3
# This line tells it to use the default ban action AND your new Discord alert
action = %(action_mw)s
         discord-alert

```


4. **Restart Fail2Ban:**
```bash
sudo systemctl restart fail2ban

```

### Test
```bash
sudo fail2ban-client set sshd banip 1.2.3.4
```

---

### How this works for an "Attacker"

1. A roommate (or an automated bot) tries to SSH into `.132` with a wrong password.
2. On the 3rd attempt, **Fail2Ban** sees the "Failed password" in `/var/log/auth.log`.
3. Fail2Ban adds a rule to your **Firewall (iptables/nftables)** to block that person's IP.
4. Immediately, your script fires off a `curl` request, and **BING!**—your phone gets a Discord notification with the attacker's IP.

---

### The "Pro" Honeypot Move

Since you mentioned earlier that you wanted to try the **Cowrie Honeypot**, this Discord setup is the first step toward that. Cowrie actually lets the attacker "log in" to a fake terminal where you can watch every command they type in real-time.

**Would you like to try "attacking" yourself now from your WSL terminal to see if the Discord alert pops up on your phone?** (Just remember your own IP so you don't ban yourself!)
