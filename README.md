# raspberry pi 4 setup
## install miniconda
```
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh
  bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
  rm ~/miniconda3/miniconda.sh

  source ~/miniconda3/bin/activate
  conda list
```
## setup git connection
```
user_name@piiv:~/raspberrypi $ ssh-keygen -t rsa -b 4096 -C "jindong-pan@foxmail.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/user_name/.ssh/id_rsa): 
/home/user_name/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/user_name/.ssh/id_rsa
Your public key has been saved in /home/user_name/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:/s9XEfDFs01khIEIBoL3SNVeUmihD18k6OPH43OniQ0 jindong-pan@foxmail.com
The key's randomart image is:
+---[RSA 4096]----+
|   ...o+==o. oo*=|
|  . o..o=oo . o++|
|   o +oo o.    o=|
|    . ++..     o.|
|     . oS       .|
|      ..+       .|
|       oE.     . |
|        o=.o. .  |
|        .o=+o.   |
+----[SHA256]-----+
user_name@piiv:~/raspberrypi $ vi ~/.ssh/id_rsa.pub 
user_name@piiv:~/raspberrypi $ eval "$(ssh-agent -s)"
Agent pid 11512
user_name@piiv:~/raspberrypi $ ssh -T git@github.com
Enter passphrase for key '/home/user_name/.ssh/id_rsa': 
Hi jindong-pan! You've successfully authenticated, but GitHub does not provide shell access.
user_name@piiv:~/raspberrypi $ 

```
# backup
```
sudo dd bs=4M if=/dev/mmcblk0p2 |gzip > /media/jeremy/Ventoy/piiv.img.gz
```
