既然你已经使用 `rsync` 配合 `--link-dest` 建立了高效的增量备份机制，恢复（Restore）的过程本质上是备份的**逆向操作**。

由于你目前居住在华盛顿州，且正在使用高性能的 AMD Ryzen 9 PRO 系统运行 Linux 环境，确保在恢复过程中处理好**权限（Permissions）**和**挂载点（Mount points）**至关重要。

以下是一个为你量身定制的恢复脚本，建议在 **Live USB** 环境下运行，或者在目标系统处于非活跃状态时执行。

---

### 🛠️ 系统恢复脚本 (restore_system.sh)

```bash
#!/bin/bash

# --- 配置信息 ---
TARGET_IP="你的备份服务器IP"
TARGET_USER="你的备份服务器用户名"
# 默认恢复 'latest'，也可以手动指定具体的日期文件夹
BACKUP_PATH="/path/to/backups/latest/" 
# 恢复目标：通常是根目录 '/'
DESTINATION="/"

# 排除列表 (恢复时不需要拉回这些虚拟文件系统的内容)
EXCLUDE=(
    --exclude='/proc/*'
    --exclude='/sys/*'
    --exclude='/dev/*'
    --exclude='/tmp/*'
    --exclude='/run/*'
    --exclude='/mnt/*'
    --exclude='/media/*'
    --exclude='/lost+found'
)

echo "⚠️  警告：即将开始恢复系统！"
echo "源地址: $TARGET_USER@$TARGET_IP:$BACKUP_PATH"
echo "目标位置: $DESTINATION"
read -p "确认要继续吗？(y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo "🚀 正在从时光机提取档案..."

# 執行 rsync 恢復
# -aAX: 保持权限、ACL 和 扩展属性 (对 Linux 系统恢复至关重要)
# -v: 显示进度
# -z: 压缩传输
# --numeric-ids: 确保 UID/GID 按数字匹配，防止因 Live 环境用户 ID 不同导致权限错乱
sudo rsync -aAXvz --numeric-ids \
    "${EXCLUDE[@]}" \
    "$TARGET_USER@$TARGET_IP:$BACKUP_PATH" "$DESTINATION"

echo "✅ 恢复完成！"
echo "💡 提示：如果是全新硬盘恢复，请记得更新 /etc/fstab 并重新安装 Grub 引导。"

```

---

### ⚠️ 恢复时的关键注意事项

1. **保持属性一致性**：你在备份时使用了 `-aAX`（归档、ACL、扩展属性），恢复时也**必须**带上这些参数，否则你的 Linux Mint 或 Lubuntu 环境会出现权限崩溃。
2. **`--numeric-ids` 的重要性**：因为你经常在不同的环境（如 WSL、VirtualBox、Lubuntu）之间切换，使用数字 ID 恢复可以确保文件所属权（Root 或你的用户 `code`）保持原样，而不会被当前运行环境的用户 ID 干扰。
3. **虚拟文件系统**：脚本中保留了 `--exclude` 虚拟目录。即使备份里没有这些数据，恢复时也不应覆盖当前运行系统的 `/proc` 或 `/sys`。
4. **SSH 密钥管理**：考虑到你正在研究网络安全和 SSH 加固，如果恢复到一个新环境，请确认是否需要手动拉回你在 Windows 上加密存储的私钥文件。

### 下一步建议

由于你之前提到过正在使用 **Cloudflare Tunnel** 暴露本地后端，如果恢复后网络配置发生变动，你可能需要重新启动 `cloudflared` 服务来恢复外部访问。

**你想让我帮你写一个专门用于恢复特定文件夹（比如只恢复你的 Web3 项目代码）的精简版脚本吗？**
