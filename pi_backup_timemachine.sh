#!/bin/bash

# --- 設定區 ---
SOURCE="/"
TARGET_USER="mint"
TARGET_IP="192.168.1.124"  # 建議換成 Tailscale IP
TARGET_DIR="/home/mint/pi_backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
CURRENT_BACKUP="$TARGET_DIR/$DATE"
LATEST_LINK="$TARGET_DIR/latest"

# 排除不需要備份的目錄
EXCLUDE=(
    --exclude='/proc/*'
    --exclude='/sys/*'
    --exclude='/dev/*'
    --exclude='/tmp/*'
    --exclude='/run/*'
    --exclude='/mnt/*'
    --exclude='/media/*'
    --exclude='/lost+found'
    --exclude='/var/lib/tailscale/*' # 視需求，若要備份金鑰則移除此行
    --exclude='**/.cache/*'     # 排除所有使用者目錄下的 .cache
    --exclude='/var/cache/*'    # 排除系統層級的套件快取
)

echo "🚀 開始執行時光機增量備份：$DATE"

# 執行 rsync
# --link-dest 會參考 'latest' 這個軟連結，只傳輸有變動的檔案
sudo rsync -aAXvz --delete \
    "${EXCLUDE[@]}" \
    --link-dest="$LATEST_LINK" \
    "$SOURCE" "$TARGET_USER@$TARGET_IP:$CURRENT_BACKUP"

# 備份完成後，更新 'latest' 軟連結指向最新一次備份
ssh "$TARGET_USER@$TARGET_IP" "rm -rf $LATEST_LINK && ln -s $CURRENT_BACKUP $LATEST_LINK"

echo "✅ 備份完成！存儲於：$CURRENT_BACKUP"
