Gatien Ryckebusch 2019-2020 étudiant université de lille

# PFE - Mise en oeuvre d'un système de fichier pair-à-pair sur raspberry pi4

Dans cette parti nous allons nous voir l'installation du systéme de fichier ceph sur des raspberry pi 4.

## Quelques informations

ip réseau : 192.168.1.0/24  
iso de la machine hote : 2019-09-26-raspbian-buster-lite.img  
login : pi  
password : raspberry  
IP :
		
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
    ceph-admin nous servira de node-admin pour la gestion des clefs.

## 1 ére étape : installation commune.

mise à jour du systéme

> sudo apt-get update -y

> sudo apt-get upgrade -y

installation de lvm

> sudo apt-get install lvm2

modification du fichier hosts 

> sudo echo -e "192.168.1.63  ceph-admin\n192.168.1.71 ceph2\n192.168.1.84 ceph3" | sudo tee -a /etc/hosts

ntp

> sudo apt install ntpdate -y

> sudo apt install ntp -y

> sudo service ntp stop

> sudo timedatectl  set-timezone Europe/Paris

> sudo timedatactl set-ntp on

> sudo ntpdate 0.fr.pool.ntp.org

ssh

> sudo sudo apt-get install openssh-server -y

> sudo systemctl enable ssh

> sudo systemctl start ssh

> echo -e "Host ceph-admin\n\tHostname ceph-admin\n\tUser ceph-admin\nHost ceph2\n\tHostname ceph2\n\tUser ceph2\nHost ceph3\n\tHostname ceph3\n\tUser ceph3\n" | sudo tee -a ~/.ssh/config

## 2 ème étape : configuration user et nom de machine

sur ceph-amdmin  
user : ceph-admin  
password : ceph  
  
    
user

> sudo useradd ceph-admin --shell /bin/bash --create-home

> sudo passwd ceph-admin

> sudo addgroup ceph-admin sudo

> echo "ceph-admin" ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ceph-admin

nom de la machine

> echo "ceph-admin" | sudo tee /etc/hostname


sur ceph2 :
user : ceph2  
password : ceph  

> sudo useradd ceph2 --shell /bin/bash --create-home

> sudo passwd ceph2

> sudo addgroup ceph2 sudo

> echo "ceph2" ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ceph2

nom de la machine

> echo "ceph2" | sudo tee /etc/hostname


sur ceph3 :
user : ceph3  
password : ceph  

> sudo useradd ceph3 --shell /bin/bash --create-home

> sudo passwd ceph3

> sudo addgroup ceph3 sudo

> echo "ceph3" ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ceph3

nom de la machine

> echo "ceph3" | sudo tee /etc/hostname


## 3 éme étape : generation des keys ssh et configuration

sur ceph-admin  
il faut laiser la phrase secrète vide.

> ssh-keygen

> ssh-copy-id ceph-admin@ceph-admin

> ssh-copy-id ceph2@ceph2

> ssh-copy-id ceph3@ceph3

## 4 éme étape : mise en place d'un systéme de fichier basic ceph.

objectif :

!(alt)[]

sur ceph-admin 

> sudo apt-get install ceph-deploy -y

creation du dossier pour les creation des clef et des fichiers de configuration

> mkdir /cluster

> cd /cluster

ceph-deploy ne dois pas être lancer en sudo si  
la commande échoue vérifier votre configuration  
ssh et votre fichier /etc/hosts.

> ceph-deploy new ceph-admin

ajout du public_network (optionnel car nous avons qu'une seul interface réseaux)

> echo "public_network = 192.168.1.0/24"

installation de ceph et copie des fichier de configuration dans les différents machines.

> ceph-deploy install ceph-admin ceph2 ceph3

deployement du premier moniteur dans ceph-admin

> ceph-deploy mon create-initial

une fois ceci fais plusieurs keys apparaitrons dans le dossier "/cluster"  
il nous reste à copier les clef admin dans les autres machines.

> ceph-deploy admin ceph-admin ceph2 ceph3

il fois la copie des clef effectuer nous allons créer 1 manager.

> ceph-deploy mgr create ceph-admin 

cette command peut nécessiter un reboot (voir plus tard)
maintemant nous allons creer 3 osd qui nous servirons de stockage physique à nôtre cluster
pour ce faire nous avons une partition de 50go dans /dev/mmcblk0p3 dans chacune de nos   
machines comme expliquer dans l'avant propos.

> ceph-deploy osd create --data /dev/mmcblk0p3 ceph2

> ceph-deploy osd create --data /dev/mmcblk0p3 ceph3

> ceph-deploy osd create --data /dev/mmcblk0p3 ceph-admin

