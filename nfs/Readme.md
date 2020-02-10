Gatien Ryckebusch 2019-2020 étudiant université de lille

# PFE - Mise en œuvre d'un système de fichier pair-à-pair sur raspberry pi4

Dans cette partie nous allons voir l'installation du système de fichiers réparties sur des raspberry pi 4 avec NFS et raid5 en local dans un même sous-réseau.


## Quelques informations

IP :
		TP1 : 192.168.0.23  disk1
		IP2 : 192.168.0.28  disk2
		TP3 : 192.168.0.40  disk3
		
IP_RESEAU : 
		
		192.168.0.0/24


## 1 ère étape : Installation commune.

Pour cette partie il suffit juste d'installer nfs-kernel-server et nfs-common

> sudo apt-get install nfs-kernel-server -y

> sudo apt-get install -y nfs-common

## 2 ème étape : création des dossiers et fichiers.

configuration à faire sur les 3 raspberry pi.
créer un répertoire qui servira de base pour établir notre système.

> mkdir /home/$USER/nfs

dans le dossier nfs ajouter 3 dossier.

> mkdir /home/$USER/nfs/disk1
> mkdir /home/$USER/nfs/disk2
> mkdir /home/$USER/nfs/disk3

création des fichiers qui serviront de disques virutels (10Go).
Sur IP1 :

> sudo dd if=/dev/zero of=/home/$USER/nfs/disk1/disk bs=1M count=10000 

Sur IP2 :

> sudo dd if=/dev/zero of=/home/$USER/nfs/disk2/disk bs=1M count=10000

sur IP3 :

> sudo dd if=/dev/zero of=/home/$USER/nfs/disk3/disk bs=1M count=10000


## 3 ème étape : configuration nfs.

maintemant il faut configurer le fichier "/etc/exports" :

Sur IP1 :
	
		/home/$USER/nfs/disk1 $IP_RESEAU(rw,all_squash,anonuid=1000,anongid=100,sync,no_subtree_check)	

Sur IP2 :

		/home/$USER/nfs/disk2 IP_RESEAU(rw,all_squash,anonuid=1000,anongid=100,sync,no_subtree_check)

Sur IP3 :

		/home/$USER/nfs/disk3 IP_RESEAU(rw,all_squash,anonuid=1000,anongid=100,sync,no_subtree_check)


maintenant relancer le service nfs

> sudo /etc/init.d/nfs-kernel-server restart

## 4 ème partie (OPTIONNEL) : auto-mount après un redémarrage "/etc/fstab".

sur IP1 :

		IP2:/home/$USER/nfs/disk2 /home/$USER/nfs/disk2 nfs rw 0 0
		IP3:/home/$USER/nfs/disk3 /home/$USER/nfs/disk3 nfs rw 0 0

sur IP2 :

		IP1:/home/$USER/nfs/disk1 /home/$USER/nfs/disk1 nfs rw 0 0
		IP3:/home/$USER/nfs/disk3 /home/$USER/nfs/disk3 nfs rw 0 0

sur IP3 :

		IP1:/home/$USER/nfs/disk1 /home/$USER/nfs/disk1 nfs rw 0 0
		IP2:/home/$USER/nfs/disk1 /home/$USER/nfs/disk2 nfs rw 0 0

## 5 ème partie : mounter les fichiers.

sur IP 1 :

		sudo mount -t nfs -o rw IP2:/home/$USER/nfs/disk2 /home/$USER/nfs/disk2
		sudo mount -t nfs -o rw IP3:/home/$USER/nfs/disk3 /home/$USER/nfs/disk3

sur IP 2 :

		sudo mount -t nfs -o rw IP1:/home/$USER/nfs/disk1 /home/$USER/nfs/disk1
		sudo mount -t nfs -o rw IP3:/home/$USER/nfs/disk3 /home/$USER/nfs/disk3

sur IP 1 :

		sudo mount -t nfs -o rw IP1:/home/$USER/nfs/disk1 /home/$USER/nfs/disk1
		sudo mount -t nfs -o rw IP2:/home/$USER/nfs/disk2 /home/$USER/nfs/disk2

le systéme de fichier nfs est maintenant mis en place sur les 3 raspberry, il ne reste plus cas monter le système RAID5.


## 6 éme partie : Montage du fichiers raid5 sur une raspberry.

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

## 7 ème partie : démontage du système.

demonte le disque RAID5 :  

> sudo umount /mnt

supression du disque raid5 :  

> sudo mdadm --stop /dev/md0

destruction des disque virtuel :  

> sudo losetup -d /dev/loop1

> sudo losetup -d /dev/loop2

> sudo losetup -d /dev/loop3


démonte le dossier nfs créer :  

> sudo umount disk1

> sudo umount disk2

> sudo umount disk3


# Sources
 

nfs :
	https://doc.ubuntu-fr.org/nfs

raid :
	https://doc.ubuntu-fr.org/raid_logiciel
