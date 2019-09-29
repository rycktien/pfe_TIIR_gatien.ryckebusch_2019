#!/bin/bash

# optionnel (*)

# mise a jour des paquet ubuntu
sudo apt update -y
sudo apt upgrade -y 
sudo apt autoremove

# installation de quelques paquet
sudo apt install vim #(*)
sudo apt install bash-completion #(*)
sudo apt-get install virtualbox
sudo apt-get install bridge-utils

#dl debian Jessie via netins
#wget https://cdimage.debian.org/cdimage/archive/8.11.1/amd64/iso-cd/debian-8.11.1-amd64-netinst.iso # 64 bits
wget https://cdimage.debian.org/cdimage/archive/8.11.1/i386/iso-cd/debian-8.11.1-i386-netinst.iso    # 32 bits

