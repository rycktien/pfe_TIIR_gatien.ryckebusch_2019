Gatien Ryckebusch 2019-2020 étudiant université de lille

# PFE - Mise en œuvre d'un système de fichier pair-à-pair sur raspberry pi4

Dans cette partie nous allons voir l'installation du système de fichiers ceph sur des raspberry pi 4.

## Quelques informations

		PI1 = 192.168.0.28
		PI2 = 192.168.0.13
		PI3 = 192.168.0.23

## 1 ère étape : Installation commune.

installation de sshfs.

> sudo apt-get install sshfs -y

## 2 ème étape : création des dossiers et fichiers.

configuration à faire sur les 3 raspberry pi.
créer un répertoire qui servira de base pour établir notre système.

> mkdir /home/$USER/sshfs

dans le dossier nfs ajouter 3 dossier.

> mkdir /home/$USER/sshfs/disk1
> mkdir /home/$USER/sshfs/disk2
> mkdir /home/$USER/sshfs/disk3

création des fichiers qui serviront de disques virutels (10Go).
Sur IP1 :

> sudo dd if=/dev/zero of=/home/$USER/sshfs/disk1/disk bs=1M count=10000 
> sudo mkfs.ext4 /home/pi/sshfs/disk1/disk

Sur IP2 :

> sudo dd if=/dev/zero of=/home/$USER/sshfs/disk2/disk bs=1M count=10000
> sudo mkfs.ext4 /home/pi/sshfs/disk2/disk

sur IP3 :

> sudo dd if=/dev/zero of=/home/$USER/sshfs/disk3/disk bs=1M count=10000
> sudo mkfs.ext4 /home/pi/sshfs/disk3/disk

## 3 ème étape : mise en place du cluster avec sshfs.

sur PI1 :

sshfs pi@PI2:/home/pi/sshfs/disk2 disk2
sshfs pi@PI3:/home/pi/sshfs/disk3 disk3

sur PI2 :

sshfs pi@PI1:/home/pi/sshds/disk1 disk1
sshfs pi@PI3:/home/pi/sshds/disk3 disk3

sur PI3 :

sshfs pi@PI1:/home/pi/sshds/disk1 disk1
sshfs pi@PI2:/home/pi/sshds/disk2 disk2



## 4 éme partie : Montage du fichiers raid5 sur une raspberry.

sur une raspberry pi ici IP1 création des disque virtuel à partir des fichiers.

> sudo losetup /dev/loop1 /home/$USER/nfs/disk1/disk 

> sudo losetup /dev/loop2 /home/$USER/nfs/disk2/disk

> sudo losetup /dev/loop3 /home/$USER/nfs/disk3/disk

création du disque Raid5 "/dev/md0"

> sudo mdadm --create /dev/md0 --level=5  --raid-devices=3 /dev/loop1 /dev/loop2 /dev/loop3

formatage du disque "/dev/md0"

> sudo mkfs.ext4 /dev/md0

mountage du disque raid 5

> sudo mount /dev/md0 /mnt

maintenant que le disque raid5 et crée et monté il vous reste à partager le dossier monté avec les autres raspberry (ici IP2,IP3), retour étape 3-5 à adapté.

## 5 ème partie : démontage du système.

demonte le disque RAID5 :  

> sudo umount /mnt

supression du disque raid5 :  

> sudo mdadm --stop /dev/md0

destruction des disque virtuel :  

> sudo losetup -d /dev/loop1

> sudo losetup -d /dev/loop2

> sudo losetup -d /dev/loop3


démonte les dossiers ou sshfs à étais monter :  

> sudo umount disk1

> sudo umount disk2

> sudo umount disk3

