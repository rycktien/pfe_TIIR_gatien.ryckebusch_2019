#!/bin/bash


# installation des paquets
sudo apt-get install openssh-server
sudo apt-get install openss-client
sudo apt-get install vim

# sauvegarde du fichier de config ssh
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
# protection en ecriture du fichier
sudo chmod a-w /etc/ssh/sshd_config.backup

sudo systemctl restart ssh
sudo systemctl enable  ssh

sudo systemctl restart ssh.socket
sudo systemctl enable  ssh.socket

