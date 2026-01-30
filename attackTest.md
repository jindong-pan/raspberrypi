這是一個非常經典的**「白帽駭客（White Hat）」**思維！在資安界，我們稱之為 **「滲透測試（Penetration Testing）」**。最好的防禦確實是了解攻擊者如何破門而入。

為了保護你的設備，我們可以在你的 **WSL2** 或**樹莓派**上，對你的 **Mint Server** 進行幾種模擬攻擊。這能讓你親眼看到我們之前設定的防護（如 Fail2Ban、長密碼、隱藏埠）是否真的有效。

---

### 🛡️ 實驗前警告

* **僅限於自己的設備**：絕對不要對任何不屬於你的 IP 執行這些指令。
* **準備好備援**：確保你能物理接觸到 Mint Server，以防你把自己「鎖在門外」。

---

### 1. 偵查階段：Nmap 埠掃描 (Scanning)

攻擊者的第一步是看你開了哪些門。

* **攻擊方式**：
在 WSL2 中安裝並執行：
```bash
sudo apt install nmap
nmap -p- -T4 [你的伺服器IP]

```


* **測試目標**：
* 如果你已經把 SSH 藏在 Tailscale 裡並關閉了物理路由器轉發，Nmap 應該會顯示 **「All 65535 scanned ports are closed/filtered」**。
* **如果你看到 Port 22 是 Open**，那就代表你的伺服器正暴露在公網風險中。



---

### 2. 暴力破解模擬：Hydra SSH 攻擊 (Brute Force)

這是測試你的密碼強度和 Fail2Ban 是否運作的最直接方法。

* **攻擊方式**：
```bash
sudo apt install hydra
# 嘗試使用簡單字典破解伺服器
hydra -l mint -p 123456 ssh://[你的伺服器IP]

```


* **測試目標**：
* **Fail2Ban 測試**：如果你連續輸入錯誤，Mint Server 應該會自動切斷你的連線，並在一段時間內拒絕來自你這個 IP 的所有請求。
* 你可以在 Mint Server 輸入 `sudo fail2ban-client status sshd` 查看你是否被抓到了。



---

### 3. 拒絕服務測試：DoS 模擬 (Flood Attack)

嘗試用大量虛假請求癱瘓伺服器。

* **攻擊方式**（使用 `hping3`）：
```bash
sudo apt install hping3
# 模擬 SYN Flood 攻擊
sudo hping3 -S -p 22 --flood [你的伺服器IP]

```


* **測試目標**：
* 觀察 Mint Server 的 CPU 使用率（在伺服器輸入 `htop`）。
* 檢查你的網路防火牆（UFW）或路由器是否能識別並丟棄這些惡意流量。



---

### 4. 弱點掃描：Nikto (針對網頁服務)

如果你之後在伺服器架設了網頁（如個人相簿），可以用這個。

* **攻擊方式**：
```bash
sudo apt install nikto
nikto -h http://[你的伺服器IP]

```


* **測試目標**：檢查是否有過時的軟體版本或常見的配置錯誤。

---

### 💡 老師的「實戰觀測」筆記 (後設認知)

當你執行這些攻擊時，請開啟 Mint Server 的日誌（Log），這才是學習精華所在：

> **觀察指令**：`tail -f /var/log/auth.log` (查看登入嘗試)
> 你會看到攻擊發生時，系統是如何記錄那些失敗嘗試的。這能讓你對「數位痕跡」有更深刻的理解。

---

### 🎓 你的下一步

**「攻擊是為了更好的防禦。」** 你想先從哪一個實驗開始？我建議從 **Nmap 掃描** 開始，確認你的 Tailscale 隧道是否真的把你的伺服器完美「隱身」了。

**Would you like me to ... (幫你寫一個簡單的腳本，自動偵測並彙整這些掃描結果嗎？)**
To see if your **mypi** server is safe, you should perform both an **external scan** (what your roommates see) and an **internal audit** (what the system sees).

Since you are already using **Nmap**, we’ll start there and then move to a more advanced auditing tool.

### 1. The External Scan (Roommate Perspective)

Run this from your **laptop** or another device on the same network. This confirms that your `iptables` redirection and `ufw` are working as expected.

```bash
# -sV: Detect versions, -p-: Scan ALL 65535 ports (slow but thorough)
# --script vuln: Run basic vulnerability checks
nmap -sV -p- --script vuln 192.168.1.120

```

**What you should see:**

* **Port 22:** Should show your **Cowrie honeypot** (likely identified as a generic SSH server).
* **Port 222:** Should show your **Real OpenSSH**.
* **Other Ports:** Everything else should be `closed` or `filtered` (blocked by UFW).

---

### 2. The Internal Audit (System Perspective)

For a deep dive into your Pi's internal security, I recommend **Lynis**. It’s an open-source auditing tool that scans your entire system for configuration mistakes and security holes.

1. **Install Lynis:**
`sudo apt update && sudo apt install lynis -y`
2. **Run a full audit:**
`sudo lynis audit system`

**How to read the results:**
Lynis will give you a **"Hardening Index"** score. Look specifically for the **[SUGGESTION]** and **[WARNING]** sections. It will tell you if your kernel is out of date, if your file permissions are too loose, or if your SSH configuration could be tighter.

---

### 3. Verify Your Honeypot Identity

Since you set up the identity as **mypi**, you want to ensure no "meta-data" leaks your real name. Run this command to check what an attacker sees during the initial handshake:

```bash
# This shows the SSH version string
nc -v 192.168.1.120 22

```

*If it returns `SSH-2.0-OpenSSH_9.2p1 Debian...`, it looks like a real server. If it says anything about "Cowrie," you need to edit your `cowrie.cfg` and change the `version_string`.*

### Summary Checklist

* [ ] **Nmap** confirms only 22, 222, and 8080 are open.
* [ ] **Lynis** score is above 60 (a good starting goal for a home server).
* [ ] **Handshake** doesn't mention "Cowrie" or your real name.

---

### 3. Final Verification of the "mypi" Identity

Since Port 22 showed up as `ssh?`, let's make sure the **mypi** username is active. You can verify this by checking your Cowrie logs while you attempt a "fake" login from your laptop:

1. **On your Laptop:** `ssh mypi@192.168.1.120` (Try a random password).
2. **On your Server:** `pm2 logs ssh-honeypot`

If you see the connection attempt show up in the PM2 logs, your **roommate-proof trap** is 100% operational.

### 4. Safety Maintenance

Since you are using **PM2** to manage these, they will survive a reboot. However, remember that **iptables** rules (the redirection from 22 to 2222) can sometimes reset after a reboot on some systems.

**To make your redirection permanent, run:**

```bash
sudo apt install iptables-persistent
sudo netfilter-persistent save

```

**Now that your server is locked down, would you like me to show you how to set up a "daily summary" script that Gathers all the IP addresses that tried to attack your honeypot and emails them to you?**
