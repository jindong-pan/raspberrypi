#!/bin/bash

echo "🛠️ 正在優化 IPFS 伺服器配置..."

# 1. 套用伺服器設定檔 (大幅降低記憶體與頻寬消耗)
ipfs config profile apply server

# 2. 限制存儲空間 (假設限制為 10GB，可根據硬碟大小調整)
ipfs config Datastore.StorageMax 7GB

# 3. 啟用自動垃圾回收 (防止硬碟爆掉)
ipfs config Datastore.GCPeriod 1h

# 4. 允許從區網訪問 Gateway (這樣你在 Windows 才能直接看樹莓派的內容)
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080

# 5. 確保 API 只允許本地訪問 (資安考量)
ipfs config Addresses.API /ip4/127.0.0.1/tcp/5001

echo "🚀 正在透過 PM2 啟動 IPFS 節點..."

# 檢查 PM2 是否存在
if ! command -v pm2 &> /dev/null; then
    echo "❌ 找不到 PM2，請先執行: sudo npm install pm2 -g"
    exit 1
fi

# 使用 PM2 啟動，並限制記憶體（若超過 500MB 自動重啟）
# 1. 先徹底刪除舊的名單紀錄（如果有的話）
pm2 delete ipfs-node 2>/dev/null

# 2. 使用標準的 start 指令重新建立
pm2 start /usr/local/bin/ipfs --name ipfs-node --max-memory-restart 500M -- daemon

echo "✅ 配置完成！"
echo "你可以執行 'pm2 logs ipfs-node' 查看日誌。"
echo "你可以執行 'ipfs stats repo' 查看目前的空間佔用。"
