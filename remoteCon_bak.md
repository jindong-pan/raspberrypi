# backup
* sudo apt install rsync ssh
* mkdir /home/[USER]/backups_pi
* From your Linux computer:
  - rsync -auzr [USER]@[RASPBERRY_IP]:/home/pat/backups/* /home/[USER]/backups_pi/
* From the Raspberry Pi:
  - rsync -auzr /home/pat/backups/* [USER]@[COMPUTER_IP]:/home/[USER]/backups_pi/
# connection
* First, generate a key on your computer (if you have already one, skip to the next step):
```
ssh-keygen -t rsa
```
* Press Enter to each question, leave the passphrase empty.
* Then transfer the public key to the Raspberry Pi:
```
rsync ~/.ssh/id_rsa.pub pi@[RASPBERRY_IP]:/home/pat/
#Last time you need to enter your password.
```
* On the Raspberry Pi, add the public key to the allowed keys:
```
cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
```
* Try to connect in ssh now. It shouldn’t ask you for a password:
```
ssh pi@[RASPBERRY_IP]
```
* now you should be able to put the rsync command in a script that will not ask for a password
```
#!/bin/bash
rsync -auzr [USER]@[RASPBERRY_IP]:/home/pat/backups/* /home/[USER]/backups_pi/
find /home/[USER]/backups_pi -mtime +8 -delete
```
