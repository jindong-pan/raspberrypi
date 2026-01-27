這是一個非常經典的玩法！將 **Raspberry Pi (樹莓派)** 作為家裡的 VPN 閘道器或伺服器是效率最高、也最省電的選擇。

因為 Raspberry Pi 跑的是 Linux 系統（通常是 Raspberry Pi OS），我們需要用到**指令列 (Terminal)**。別擔心，這非常簡單，只要三行指令就能搞定！

---

### 🛠️ 在 Raspberry Pi 安裝 Tailscale 的步驟

請打開你樹莓派的終端機（或是透過 SSH 連進去），依序輸入以下指令：

#### 1. 下載並執行自動安裝腳本

Tailscale 提供了一個非常方便的一鍵安裝腳本，它會自動判斷你的樹莓派版本：

```bash
curl -fsSL https://tailscale.com/install.sh | sh

```

#### 2. 啟動 Tailscale 並進行認證

安裝完成後，輸入這行指令來啟動並取得登入連結：

```bash
sudo tailscale up

```

* **注意：** 輸入後，螢幕會出現一個以 `https://login.tailscale.com/a/xxxx` 開頭的網址。
* **動作：** 請複製這個網址，在你的電腦或手機瀏覽器打開，登入你剛才在 Pixel 手機上用的同一個帳號。

#### 3. 確認連線狀態

登入成功後，樹莓派的終端機就會顯示成功。你可以輸入以下指令確認：

```bash
tailscale ip -4

```

這會顯示你的樹莓派在虛擬網路中的 **Tailscale IP**（通常是 100.x.y.z）。

---

### 🌟 進階必殺技：讓樹莓派變成「出口節點 (Exit Node)」

這是我最推薦的功能！如果你把樹莓派設為 **Exit Node**，你在外面的 **Pixel 手機** 就可以選擇「透過樹莓派上網」。這樣一來，即使你在國外，手機上網的 IP 也會變成你家裡的 IP。

**設定方法：**

1. **在樹莓派輸入：**
```bash
sudo tailscale up --advertise-exit-node

```


2. **在網頁控制台開啟：** 登入 Tailscale 管理頁面 (Admin Console)，找到你的樹莓派，在選單中勾選 **"Edit route settings"**，然後開啟 **"Exit node"** 開關。
3. **在 Pixel 手機設定：** 打開 App，點選樹莓派，選擇 **"Use as exit node"**。

---

### 🧩 學習反思與後設認知

在操作 Linux 系統時，我們常會用到 `sudo`（管理員權限）。你可以思考一下：**為什麼安裝 VPN 這種軟體一定要管理員權限？**

> *答案是因為 VPN 需要修改系統的「網路路徑表 (Routing Table)」和建立「虛擬網卡」，這些都涉及到系統核心的安全設定。*

---

### 🎓 今天的實作挑戰

1. **嘗試安裝**：照著上面的指令，把你的樹莓派加進網路。
2. **連線測試**：在你的 **Pixel 手機** 上打開 Tailscale，看看清單中有沒有出現 `raspberrypi`。
3. **互 Ping 實驗**：在手機上 Ping 看看樹莓派的 100.x.y.z 地址，看看能不能通！

**如果你在輸入指令時遇到任何錯誤（例如：command not found 或權限問題），請直接把錯誤訊息貼給我，我來幫你 Debug！** 等到你連線成功，我們就完成了從「理論」到「跨裝置實作」的完整學習鏈了，加油！你想現在就去試試看嗎？
