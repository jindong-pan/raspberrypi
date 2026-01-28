這是一個非常明智的決定！在 SSH 登入中加入 **Google Authenticator (2FA)**，能讓你原本的「長密碼」防禦力直接翻倍。

即便駭客透過「社交工程」騙到了你的密碼，或者你之前的密碼不小心外洩了，只要他手頭上沒有你的 **Pixel 10** 手機，他就絕對進不去你的 Mint 伺服器。

以下是為你的 Linux 伺服器安裝「動態密碼鎖」的步驟：

---

### 🛠️ 為 SSH 安裝 Google Authenticator

我們需要在你的 **Mint 伺服器**（目的地）上執行以下操作：

#### 1. 安裝套件

```bash
sudo apt update
sudo apt install libpam-google-authenticator

```

#### 2. 設定你的專屬密鑰

在終端機輸入：

```bash
google-authenticator

```

這時會出現一系列問題，建議這樣選：

* **Do you want authentication tokens to be time-based?** ➔ **y** (這是重點)
* **掃描螢幕上的 QR Code**：打開你手機上的 Google Authenticator App，掃描它。
* **Do you want me to update your "/home/mint/.google_authenticator" file?** ➔ **y**
* **其他問題**：通常選 **y** (防止同一個代碼被重複使用、擴大時間容錯等)。

**⚠️ 重要：** 螢幕會顯示幾個 **Emergency scratch codes**（緊急救援碼），請務必把它們抄在紙上收好！如果你手機掉了，這就是唯一的救命稻草。

---

### ⚙️ 修改 SSH 設定（讓它生效）

安裝好後，我們要告訴 Linux：**「嘿！現在登入除了密碼，還要問動態碼。」**

1. **修改 PAM 設定**：
`sudo nano /etc/pam.d/sshd`
在檔案最末尾加入：
`auth required pam_google_authenticator.so`
2. **修改 SSHD 設定**：
`sudo nano /etc/ssh/sshd_config`
找到 `KbdInteractiveAuthentication` (或 `ChallengeResponseAuthentication`)，確保它是：
`KbdInteractiveAuthentication yes`
3. **重啟服務**：
`sudo systemctl restart ssh`

---

### 💡 老師的「防反鎖」大絕招 (後設認知)

這是一個新手最常犯的錯誤：**「改完設定重啟後，把自己鎖在外面。」**

> **專業操作：**
> 在你重啟 SSH 服務後，**「千萬不要」**關掉目前的連線視窗！
> 1. 請另外開一個新的終端機視窗嘗試連線。
> 2. 如果新視窗成功要求你輸入 `Verification code`（驗證碼）且登入成功，那才代表大功告成。
> 3. 如果失敗了，你原本那個沒關掉的視窗還能幫你把設定改回來。
> 
> 

---

### 🎓 最終的防禦樣貌

現在當你要連線到伺服器時，過程會變這樣：

1. 輸入 SSH 指令。
2. 系統要求：`Password:` (輸入你的長密碼)。
3. 系統要求：`Verification code:` (拿出手機，輸入 6 位數數字)。

**這就是所謂的「雙重驗證」：你知道的東西（密碼） + 你擁有的東西（手機）。**

你想現在在 Mint 伺服器上試試看嗎？如果在設定過程中遇到任何問題（例如 QR Code 顯示不全），隨時告訴我！我也能教你如何針對 **Tailscale 內部連線** 豁免 2FA，讓你更方便。**你想試試看設定嗎？**
