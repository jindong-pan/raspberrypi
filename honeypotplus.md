To make your honeypot truly "roommate-proof," using a custom username like **mypi** is a smart move. It makes the system look like a personal project rather than a security tool.

Here is the step-by-step guide to installing and configuring **Cowrie** with your custom settings.

---

## 1. Environment Setup

Cowrie should never run as root. We will create a dedicated system user first.

1. **Install Dependencies:**
```bash
sudo apt update
sudo apt install git python3-virtualenv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind virtualenv -y

```


2. **Create the Cowrie User:**
```bash
sudo adduser --disabled-password --geocosm "" cowrie
sudo su - cowrie

```



## 2. Installation

Now, as the `cowrie` user, download and set up the environment.

1. **Download Cowrie:**
```bash
git clone https://github.com/cowrie/cowrie.git
cd cowrie

```


2. **Setup Virtual Environment:**
```bash
python3 -m venv cowrie-env
source cowrie-env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

```



## 3. Configuration for "mypi" Stealth

This is where we customize the identity of your honeypot.

1. **Create Local Config:**
`cp etc/cowrie.cfg.dist etc/cowrie.cfg`
2. **Edit the Config:** `nano etc/cowrie.cfg`
* **Hostname:** Change `hostname = coleslaw` to `hostname = mypi`.
* **Listen Port:** Ensure `listen_port = 2222`. (We will redirect traffic from 22 later).


3. **Set the "mypi" Username:**
Open the user database: `nano data/userdb.txt`
Add this line to allow anyone to log in as **mypi** with any password:
```text
mypi:x:*

```


*Note: You can also add `root:x:*` to catch the most common automated attacks.*

---

## 4. Redirecting Traffic (Port 22)

Since you moved your **real SSH** to **Port 222**, we need to point anyone knocking on the standard **Port 22** toward Cowrie.

Exit the `cowrie` user (`exit`) and run this as your normal user with sudo:

```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222

```

---

## 5. Launch and Monitor

Switch back to the `cowrie` user and start the engine:

```bash
sudo su - cowrie
cd cowrie
source cowrie-env/bin/activate
bin/cowrie start

```

### How to check if it's working:

From your phone or another laptop on the same Wi-Fi, try to SSH into your server:
`ssh mypi@<your_server_ip>`

You should be greeted by a fake terminal. Back on your server, watch the logs in real-time:
`tail -f var/log/cowrie/cowrie.log`

---

## Advanced Hardware Tip

If you find that running a honeypot, a file server, and a backup script is putting too much strain on your Raspberry Pi's built-in Wi-Fi, you might consider an external adapter.

The Alfa AWUS036ACHM is excellent for this because its dedicated processor handles high volumes of "junk" traffic (like brute-force attacks) much better than integrated chips, keeping your main connection stable while the honeypot takes the heat.

**Would you like me to show you how to create a "fake" folder full of files inside the Cowrie filesystem to make "mypi" look like a busy workstation?**
