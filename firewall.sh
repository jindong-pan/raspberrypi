#!/usr/bin/sh
sudo ufw default deny incoming
sudo ufw allow 22/tcp
sudo ufw allow 8080/tcp
sudo ufw enable
