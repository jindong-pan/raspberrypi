# SSH
## install ssh-server
```bash
sudo apt update && sudo apt install openssh-server
```
## start SSH
```bash
sudo systemctl start ssh
# startup ssh
sudo systemctl enable ssh
```
## check
```bash
sudo systemctl status sshd
```
## firewall
```bash
sudo ufw allow ssh
# or
sudo ufw allow 22/tcp
```
## safer config
```bash
sudo nano /etc/ssh/sshd_config
# change port to 2222 (update firewall)
# port 2222
# PermitRootLogin no
# PasswordAuthentication no (if you set key)
```
## restart ssh
```
sudo systemctrl restart sshd

```

