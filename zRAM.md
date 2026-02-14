# zRAM
## install
```bash
sudo apt update && sudo apt install zram-tools
```
## setup
```bash
sudo nano /etc/default/zramswap
# ALGO=zstd
# lz4:fast zstd:belanced lzo/lzo-rle:default
PERCENT=20-70 #4G RAM
PRIORITY=100
```
## restart
```bash
sudo systemctl restart zramswap
```
