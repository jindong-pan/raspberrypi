Using **PM2** to manage your listener script is an excellent idea. Since you're already familiar with technical setups like **Cloudflare tunnels** and **SSH servers**, you'll appreciate how PM2 turns a simple loop into a resilient **background service**.

While your current `while` loop is efficient, if the script crashes or the server reboots, the listener stops. **PM2** ensures the "honeypot" stays active without you needing to manually restart it.

### Why PM2 is Better for Your Setup

* **Auto-Restart:** If the `nc` command fails or the process is killed, PM2 brings it back up **instantly**.
* **Startup Persistence:** You can configure PM2 to start the listener automatically when your **Ryzen 9** or **Raspberry Pi** boots up.
* **Log Management:** PM2 can handle log rotation, preventing your `intruder_log.txt` from growing so large it eats up your disk space.

---

### How to Set It Up

First, ensure you have **Node.js** and **PM2** installed:
```bash
sudo apt install nodejs npm && sudo npm install pm2@latest -g
# install netcat
sudo apt update && sudo apt install netcat-traditional -y
```

#### 1. Create a Dedicated Script File

redirect 22 to 2222
```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
```

Instead of a one-liner, put your logic into a simple bash script (e.g., `honeypot.sh`):

```bash
#!/bin/bash
while true; do
  echo "--- Connection at $(date) ---" >> /home/$(whoami)/intruder_log.txt
  # Use -v to see the attacker's IP and 2>&1 to capture those details
  nc -v -l -p 2222 2>&1 >> /home/$(whoami)/intruder_log.txt
done

```

*Make it executable:* `chmod +x honeypot.sh`

#### 2. Start it with PM2

```bash
pm2 start honeypot.sh --name "ssh-honeypot"

```

#### 3. Make it Survive Reboots

```bash
pm2 save
pm2 startup

```

*(Follow the instruction on the screen to copy/paste the command PM2 provides to finalize the startup script).*

---

### Managing the Logs

Since you're worried about your server being **roommate-proof**, you can monitor the "attacks" in real-time with:
`pm2 logs ssh-honeypot`

This will show you exactly when someone tries to connect to **Port 22** without you having to manually open the text file.

### Important Reminder

Since your **Nmap scan** showed **Port 3389 (RDP)** and **Port 5900 (VNC)** are open, PM2 can also be used to manage other "safety" scripts, like **automated backups** to your remote SSH server.

Would you like me to help you write a PM2-managed script that **automatically backups** your intruder logs to your remote server every night?
