#### Gatien Ryckebusch

## introduction

Dans cette partie nous allons référencer quelques resultat que nous avons obtenues.
Nous avons commencer par un test de performance sur les différent systéme de stockage de la RASPBERRI PI 4 :

		carte SD;
		USB2;
		USB3;
		RAM.

Puis nous avons décidé de rester sur la carte SD pour tester les différentes systèmes partagés mis en place :
		
		sshfs
		nfs

## RAM, SD, USB2, USB3

### RAM

Pour test la ram ono doit y monter un dossier dessus :  

> sudo mount -t tmpfs -o size=2G tmpfs /tmpfs 

Quand on ecrira dans le dossier /tmpfs alors le contenue sera stocker directement en ram et non sur le disque.  

#### Test

on test avec fio :

> fio --name=global --rw=randread --size=2g --name=job --filename=/tmpfs/test ## 4Go

		fio --name=global --rw=randread --size=2g --name=job --filename=/ramFs/tst
		job: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
		fio-3.12
		Starting 1 process
		job: Laying out IO file (1 file / 2048MiB)
		Jobs: 1 (f=1): [r(1)][100.0%][r=399MiB/s][r=102k IOPS][eta 00m:00s]
		job: (groupid=0, jobs=1): err= 0: pid=4225: Sun Nov 24 16:34:51 2019
		  read: IOPS=103k, BW=403MiB/s (422MB/s)(2048MiB/5083msec)
		    clat (usec): min=3, max=660, avg= 5.97, stdev= 1.60
		     lat (usec): min=4, max=660, avg= 6.52, stdev= 1.74
		    clat percentiles (nsec):
		     |  1.00th=[ 4384],  5.00th=[ 4704], 10.00th=[ 5280], 20.00th=[ 5536],
		     | 30.00th=[ 5600], 40.00th=[ 5728], 50.00th=[ 5792], 60.00th=[ 5856],
		     | 70.00th=[ 5920], 80.00th=[ 6048], 90.00th=[ 6240], 95.00th=[ 9536],
		     | 99.00th=[10048], 99.50th=[10176], 99.90th=[10816], 99.95th=[27008],
		     | 99.99th=[32640]
		   bw (  KiB/s): min=408312, max=415624, per=100.00%, avg=412620.70, stdev=2377.25, samples=10
		   iops        : min=102078, max=103906, avg=103155.10, stdev=594.32, samples=10
		  lat (usec)   : 4=0.02%, 10=98.71%, 20=1.20%, 50=0.06%, 100=0.01%
		  lat (usec)   : 250=0.01%, 750=0.01%
		  cpu          : usr=30.03%, sys=69.85%, ctx=54, majf=0, minf=18
		  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
		     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
		     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
		     issued rwts: total=524288,0,0,0 short=0,0,0,0 dropped=0,0,0,0
		     latency   : target=0, window=0, percentile=100.00%, depth=1

		Run status group 0 (all jobs):
		   READ: bw=403MiB/s (422MB/s), 403MiB/s-403MiB/s (422MB/s-422MB/s), io=2048MiB (2147MB), run=5083-5083msec

> fio --name=global --rw=randread --size=100g --name=job --filename=/tmpfs/test ## 100Go

		job: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
		fio-3.12
		Starting 1 process
		job: Laying out IO file (1 file / 102400MiB)
		fio: ENOSPC on laying out file, stopping
		Jobs: 1 (f=1): [r(1)][100.0%][r=553MiB/s][r=141k IOPS][eta 00m:00s]
		job: (groupid=0, jobs=1): err= 0: pid=4327: Sun Nov 24 17:07:13 2019
		  read: IOPS=148k, BW=579MiB/s (607MB/s)(100GiB/176898msec)
		    clat (nsec): min=2740, max=747703, avg=3149.05, stdev=781.45
		     lat (nsec): min=3259, max=763278, avg=3667.82, stdev=809.22
		    clat percentiles (nsec):
		     |  1.00th=[ 2864],  5.00th=[ 2896], 10.00th=[ 2960], 20.00th=[ 2992],
		     | 30.00th=[ 3024], 40.00th=[ 3056], 50.00th=[ 3088], 60.00th=[ 3088],
		     | 70.00th=[ 3120], 80.00th=[ 3120], 90.00th=[ 3152], 95.00th=[ 3152],
		     | 99.00th=[ 7328], 99.50th=[ 7776], 99.90th=[11584], 99.95th=[12352],
		     | 99.99th=[14784]
		   bw (  KiB/s): min=564144, max=599280, per=100.00%, avg=592747.20, stdev=7245.41, samples=353
		   iops        : min=141036, max=149820, avg=148186.84, stdev=1811.40, samples=353
		  lat (usec)   : 4=97.94%, 10=1.90%, 20=0.16%, 50=0.01%, 100=0.01%
		  lat (usec)   : 250=0.01%, 500=0.01%, 750=0.01%
		  cpu          : usr=42.07%, sys=57.91%, ctx=588, majf=0, minf=17
		  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
		     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
		     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
		     issued rwts: total=26214400,0,0,0 short=0,0,0,0 dropped=0,0,0,0
		     latency   : target=0, window=0, percentile=100.00%, depth=1

		Run status group 0 (all jobs):
		   READ: bw=579MiB/s (607MB/s), 579MiB/s-579MiB/s (607MB/s-607MB/s), io=100GiB (107GB), run=176898-176898msec


> fio --name=global --rw=randread --size=2g --name=job --readwrite=randrw --filename=/tmpfs/test

		job: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
		fio-3.12
		Starting 1 process
		job: Laying out IO file (1 file / 2048MiB)
		Jobs: 1 (f=1): [m(1)][100.0%][r=170MiB/s,w=171MiB/s][r=43.6k,w=43.8k IOPS][eta 00m:00s]
		job: (groupid=0, jobs=1): err= 0: pid=4736: Sun Nov 24 17:49:42 2019
		  read: IOPS=43.8k, BW=171MiB/s (180MB/s)(1023MiB/5975msec)
		    clat (nsec): min=7019, max=90723, avg=8501.83, stdev=1305.87
		     lat (nsec): min=7537, max=91260, avg=9037.46, stdev=1323.49
		    clat percentiles (nsec):
		     |  1.00th=[ 7584],  5.00th=[ 7712], 10.00th=[ 7840], 20.00th=[ 7968],
		     | 30.00th=[ 8032], 40.00th=[ 8160], 50.00th=[ 8256], 60.00th=[ 8256],
		     | 70.00th=[ 8384], 80.00th=[ 8640], 90.00th=[ 8896], 95.00th=[11840],
		     | 99.00th=[12480], 99.50th=[12736], 99.90th=[14016], 99.95th=[34048],
		     | 99.99th=[37120]
		   bw (  KiB/s): min=173424, max=177696, per=100.00%, avg=175626.91, stdev=1422.65, samples=11
		   iops        : min=43356, max=44426, avg=43906.91, stdev=355.95, samples=11
		  write: IOPS=43.9k, BW=172MiB/s (180MB/s)(1025MiB/5975msec); 0 zone resets
		    clat (nsec): min=4908, max=75778, avg=6173.54, stdev=1193.41
		     lat (nsec): min=5519, max=76426, avg=6825.50, stdev=1216.48
		    clat percentiles (nsec):
		     |  1.00th=[ 5344],  5.00th=[ 5536], 10.00th=[ 5600], 20.00th=[ 5728],
		     | 30.00th=[ 5792], 40.00th=[ 5856], 50.00th=[ 5920], 60.00th=[ 5984],
		     | 70.00th=[ 6048], 80.00th=[ 6176], 90.00th=[ 6368], 95.00th=[ 9536],
		     | 99.00th=[ 9920], 99.50th=[10176], 99.90th=[10688], 99.95th=[29312],
		     | 99.99th=[34048]
		   bw (  KiB/s): min=173896, max=177664, per=100.00%, avg=175690.91, stdev=1024.23, samples=11
		   iops        : min=43474, max=44416, avg=43922.73, stdev=256.06, samples=11
		  lat (usec)   : 10=96.10%, 20=3.82%, 50=0.07%, 100=0.01%
		  cpu          : usr=27.59%, sys=72.25%, ctx=19, majf=0, minf=18
		  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
		     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
		     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
		     issued rwts: total=261946,262342,0,0 short=0,0,0,0 dropped=0,0,0,0
		     latency   : target=0, window=0, percentile=100.00%, depth=1

		Run status group 0 (all jobs):
		   READ: bw=171MiB/s (180MB/s), 171MiB/s-171MiB/s (180MB/s-180MB/s), io=1023MiB (1073MB), run=5975-5975msec
		  WRITE: bw=172MiB/s (180MB/s), 172MiB/s-172MiB/s (180MB/s-180MB/s), io=1025MiB (1075MB), run=5975-5975msec

on a aussi essayer avec iozone le dossier se trouver dans :  

https://github.com/rycktien/pfe_TIIR_gatien.ryckebusch_2019/tree/master/test_perf/log/iozone/PI4_RAM.xls  

Avec la commande dd :  

> dd if=/dev/zero of=speedtest bs=100M count=100

21+0 records in
20+0 records out
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 6.02137 s, 357 MB/s


### USB2 (TEST)

avec la commade dd :  

>  dd if=/dev/zero of=speedtest bs=1M count=1000 conv=fdatasync ## usb 2

		1000+0 records in
		1000+0 records out
		1048576000 bytes (1.0 GB, 1000 MiB) copied, 115.52 s, 9.1 MB/s


Avec hdparm :

> hdparm -tT /dev/sda2 ## usb 2

		/dev/sda2:
		 Timing cached reads:   1498 MB in  2.00 seconds = 748.88 MB/sec
		SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 00 24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		 Timing buffered disk reads:  56 MB in  3.02 seconds =  18.55 MB/sec

Avec iozone :

https://github.com/rycktien/pfe_TIIR_gatien.ryckebusch_2019/tree/master/test_perf/log/iozone/PI4_USB2.xls  


### USB3 (TEST)

Avec la command dd :  

> dd if=/dev/zero of=speetest bs=1M count=1000 conv=fdatasync ## usb3

		1000+0 records in
		1000+0 records out
		1048576000 bytes (1.0 GB, 1000 MiB) copied, 81.5468 s, 12.9 MB/s

Avec hdparm :

> hdparm -tT /dev/sdb2 ## usb 3

		/dev/sdb2:
		 Timing cached reads:   1500 MB in  2.00 seconds = 749.78 MB/sec
		SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 00 24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		 Timing buffered disk reads:  58 MB in  3.00 seconds =  19.30 MB/sec

Avec iozone :

https://github.com/rycktien/pfe_TIIR_gatien.ryckebusch_2019/tree/master/test_perf/log/iozone/PI4_USB3.xls  

### CARTE SD (TEST)


Avec la command dd :  

> dd if=/dev/zero of=speedtest bs=100M count=100 conv=fdatasync

		89+0 records in
		89+0 records out
		9332326400 bytes (9.3 GB, 8.7 GiB) copied, 278.383 s, 33.5 MB/s

Avec hdparm :  

> hdparm -tT /dev/mmcblk0p3 ## sd

		/dev/mmcblk0p3:
		 Timing cached reads:   1708 MB in  2.00 seconds = 853.89 MB/sec
		 HDIO_DRIVE_CMD(identify) failed: Invalid argument
		 Timing buffered disk reads: 134 MB in  3.00 seconds =  44.66 MB/sec

Avec Fio :  

> sudo fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test

		filename=random_read_write.fio --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75
		test: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
		fio-3.12
		Starting 1 process
		test: Laying out IO file (1 file / 4096MiB)
		Jobs: 1 (f=1): [m(1)][100.0%][r=5409KiB/s,w=1929KiB/s][r=1352,w=482 IOPS][eta 00m:00s]
		test: (groupid=0, jobs=1): err= 0: pid=3393: Sun Nov 24 12:23:39 2019
		  read: IOPS=1160, BW=4644KiB/s (4755kB/s)(3070MiB/676965msec)
		   bw (  KiB/s): min= 1624, max= 6800, per=99.98%, avg=4642.25, stdev=652.31, samples=1353
		   iops        : min=  406, max= 1700, avg=1160.54, stdev=163.09, samples=1353
		  write: IOPS=387, BW=1552KiB/s (1589kB/s)(1026MiB/676965msec); 0 zone resets
		   bw (  KiB/s): min=  544, max= 2048, per=100.00%, avg=1551.60, stdev=210.45, samples=1353
		   iops        : min=  136, max=  512, avg=387.90, stdev=52.61, samples=1353
		  cpu          : usr=2.43%, sys=14.40%, ctx=1115415, majf=0, minf=18
		  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
		     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
		     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
		     issued rwts: total=785920,262656,0,0 short=0,0,0,0 dropped=0,0,0,0
		     latency   : target=0, window=0, percentile=100.00%, depth=64

		Run status group 0 (all jobs):
		   READ: bw=4644KiB/s (4755kB/s), 4644KiB/s-4644KiB/s (4755kB/s-4755kB/s), io=3070MiB (3219MB), run=676965-676965msec
		  WRITE: bw=1552KiB/s (1589kB/s), 1552KiB/s-1552KiB/s (1589kB/s-1589kB/s), io=1026MiB (1076MB), run=676965-676965msec

		Disk stats (read/write):
		  mmcblk0: ios=783392/262676, merge=2426/347, ticks=36039495/6993021, in_queue=1889580, util=99.74%


## SSHFS et NFS

Pour test on a utiliser que la command dd.
On à juste testée la vitesse écriture car en général la vitesse de lecture est plus rapide.

### SSHFS 3 RASPBERRY en local

> sudo dd if=/dev/zero of=test bs=1M count=10000

		10000+0 records in
		10000+0 records out
		10485760000 bytes (10 GB, 9.8 GiB) copied, 469.4 s, 21.3 MB/s



### NFS  3 RASPBERRY en local

> sudo dd if=/dev/zero of=test bs=1M count=1000

		1000+0 records in
		1000+0 records out
		1048576000 bytes (1.0 GB, 1000 MiB) copied, 23.5603 s, 44.5 MB/s

> sudo dd if=/dev/zero of=test bs=1M count=10000

		10000+0 records in
		10000+0 records out
		10485760000 bytes (10 GB, 9.8 GiB) copied, 266.712 s, 39.3 MB/s

> sudo dd if=/dev/zero of=test bs=1M count=10000

		10000+0 records in
		10000+0 records out
		10485760000 bytes (10 GB, 9.8 GiB) copied, 255.628 s, 41.0 MB/s


### SSHFS 2 RASPBERRIE en local et 1 à distant

> dd if=/dev/zero of=test bs=1M count=10000

		10000+0 records in
		10000+0 records out
		10485760000 bytes (10 GB, 9.8 GiB) copied, 1571.98 s, 6.7 MB/s

> dd if=/dev/zero of=test bs=1M count=10000
		
		10000+0 records in
		10000+0 records out
		10485760000 bytes (10 GB, 9.8 GiB) copied, 1222.62 s, 8.6 MB/s

### NFS 2 RASPBERRIE en local et 1 à distant

> sudo dd if=/dev/zero of=disk bs=1M count=10000

		10000+0 records in
		10000+0 records out
		10485760000 bytes (10 GB, 9.8 GiB) copied, 1872.27 s, 5.6 MB/s

## Résultat 

Nous pouvons observer que globalement le carte SD pour les raspberrie pi 4 reste le moyen le plus rapide pour transfert des fichiers.

pour un système de fichier distributer nous pouvons observer que NFS et plus rapide que SSHFS en local.
Mais le problème de NFS est qu'il ne chiffre pas les données qui transite dans le cloud ce qui peux être un faille de sécurité contrairement à SSHFS qui chriffre toutes communication.

## RESTE à faire

Il faudrait afinée les tests mais aussi de mettre en place un système de ficier ceph pour le comparer au NFS et SSHFS. 


##  lien

https://www.slashroot.in/linux-file-system-read-write-performance-test





