#!/usr/bin/sh
#sudo apt update
#sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw allow 22/tcp
sudo ufw allow 222/tcp
sudo ufw allow 2222/tcp
sudo ufw allow 8080/tcp
sudo ufw enable
