Switching to Google DNS on Linux is a smart move if you're looking for a bit more speed and reliability. Since "Linux" covers everything from servers to Steam Decks, there are two main ways to do this depending on whether you're using a desktop interface or the command line.

Google’s DNS addresses are:

* **IPv4:** `8.8.8.8` and `8.8.4.4`
* **IPv6:** `2001:4860:4860::8888` and `2001:4860:4860::8844`

---

## Method 1: Using the GUI (Ubuntu, Fedora, Mint, etc.)

Most modern Linux desktops use **NetworkManager**. This is the easiest way to ensure your settings stick after a reboot.

1. Open your **Settings** and go to **Network** (or Wi-Fi).
2. Click the **Cog/Gear icon** next to your active connection.
3. Go to the **IPv4** tab.
4. Switch **DNS "Automatic"** to **OFF**.
5. In the DNS field, enter: `8.8.8.8, 8.8.4.4`
6. (Optional) Do the same for the **IPv6** tab using the IPv6 addresses above.
7. Click **Apply** and toggle your Wi-Fi/Ethernet off and back on.

---

## Method 2: The Command Line (systemd-resolved)

Most modern distributions (like Ubuntu 18.04+ or Arch) use `systemd-resolved`. Editing `/etc/resolv.conf` directly is often overwritten, so it's better to edit the config file.

1. **Open the configuration file:**
`sudo nano /etc/systemd/resolved.conf`
2. **Find the `[Resolve]` section and edit the DNS line:**
Uncomment the `DNS=` line (remove the `#`) and add the addresses:
```text
[Resolve]
DNS=8.8.8.8 8.8.4.4
FallbackDNS=1.1.1.1

```


3. **Save and exit** (`Ctrl + O`, `Enter`, then `Ctrl + X`).
4. **Restart the service:**
`sudo systemctl restart systemd-resolved`

---

## Method 3: The "Old School" Way (Servers/Static)

If you aren't using a network manager (common on headless servers), you can edit the resolver file directly, though be warned: some programs might overwrite this.

1. `sudo nano /etc/resolv.conf`
2. Add or change the nameserver lines:
```text
nameserver 8.8.8.8
nameserver 8.8.4.4

```



---

## How to Verify It's Working

To make sure you're actually talking to Google and not your ISP, run this command in your terminal:

`dig google.com`

Look for the **"SERVER"** line at the bottom of the output. It should show `8.8.8.8`.

Would you like me to show you how to set this up specifically for a WSL (Windows Subsystem for Linux) instance, as that requires a slightly different approach?
