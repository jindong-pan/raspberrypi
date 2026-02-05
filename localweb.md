There are several alternatives to **ngrok**, and the "best" one depends on whether you want something free, open-source, or ultra-simple.

Since you've been working with **SSH**, **Raspberry Pi**, and **network security**, some of these might actually fit your current workflow better than ngrok.

---

### 1. The "No-Install" Alternatives (SSH-Based)

These use the SSH tools already on your machine, meaning you don’t have to download any extra binaries.

* **[Pinggy](https://pinggy.io):** Extremely simple. One command gives you a public URL. It also supports **UDP**, which ngrok’s free tier lacks.
* *Command:* `ssh -p 443 -R0:localhost:8080 a.pinggy.io`


* **[localhost.run](https://localhost.run):** Similar to Pinggy, no account or installation required.
* *Command:* `ssh -R 80:localhost:8080 localhost.run`


* **[Serveo](https://serveo.net):** A great no-install option that supports custom subdomains and SSH port forwarding.

### 2. The Powerhouse (Free & Secure)

* **[Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/):** This is arguably the strongest competitor.
* **Pros:** Totally free, unlimited bandwidth, and no public IP exposure. It integrates with Cloudflare’s security (DDoS protection, WAF).
* **Cons:** Requires you to own a domain and have it pointed to Cloudflare. The setup is a bit more involved (`cloudflared`).



### 3. The Open-Source & Self-Hosted Options

If you want total control over your data (and since you're comfortable with Linux system administration), these are excellent:

* **[frp (Fast Reverse Proxy)](https://github.com/fatedier/frp):** Highly popular for those who have a cheap VPS and want to build their own "ngrok" service. It supports TCP, UDP, and encryption.
* **[zrok](https://zrok.io):** An open-source, zero-trust alternative built on OpenZiti. It allows for private sharing (only specific people can see the link) as well as public.
* **[Bore](https://github.com/ekzhang/bore):** A modern, minimal tunnel written in Rust. It’s designed to be dead simple to self-host.

### 4. The VPN-Style Approach

* **[Tailscale Funnel](https://tailscale.com/kb/1223/funnel/):** If you already use Tailscale to manage your Raspberry Pi and Pixel 10, "Funnel" lets you take a service that is private to your Tailnet and expose it to the public internet with one command.

---

### Comparison at a Glance

| Feature | ngrok | Cloudflare Tunnel | Pinggy | frp |
| --- | --- | --- | --- | --- |
| **Setup** | Easy (CLI) | Medium | Easiest (SSH) | Hard (Self-hosted) |
| **Free Tier** | 1GB Bandwidth | **Unlimited** | Unlimited | N/A (Self-hosted) |
| **UDP Support** | Paid only | Yes | **Yes** | **Yes** |
| **Open Source** | No | Yes (`cloudflared`) | No | **Yes** |

Given your interest in **mining Monero** and **network security**, **Pinggy** or **frp** might be particularly interesting to you since they handle UDP and TCP traffic more flexibly than ngrok's free version.

Would you like the specific steps to set up a **Cloudflare Tunnel** or **frp** on your Raspberry Pi?
