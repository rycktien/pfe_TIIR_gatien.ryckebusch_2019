Gatien Ryckebusch 2019-2020 étudiant université de lille

# PFE - Mise en oeuvre d'un système de fichier pair-à-pair sur raspberry pi4

Dans cette parti nous allons nous voir l'installation du systéme de fichier ceph sur des raspberry pi 4.

##quelques informations


		iso de la machine hote           : 2019-09-26-raspbian-buster-lite.img
    login:pi
	  password:raspberry
		
  
IP:  

		Nom         |  adresse IP
		ceph-admin  | 192.168.1.63
		ceph2       | 192.168.1.71
		ceph3       | 192.168.1.84
    
    
Avant-propos: 
    
    nous avons à une carte SD de 512Go partionnée de cette maniére pour les 3 raspberry.
    Disk /dev/mmcblk0: 476.9 GiB :
        /dev/mmcblk0p1           8192    532479    524288  256M  c W95 FAT32 (LBA)  # BOOT
        /dev/mmcblk0p2         532480 210247679 209715200  100G 83 Linux            # / 
        /dev/mmcblk0p3      210247680 315105279 104857600   50G 83 Linux            # partition de stockage utiliser par ceph
    la place non utiliser est garder pour le futur.

## 1 ére étape : installation commune.

> sssss
> ssss

## 2 ème étape : virtualBox et config des MVs

## 3 éme étape : installation du system de fichier ceph dans les MVs


