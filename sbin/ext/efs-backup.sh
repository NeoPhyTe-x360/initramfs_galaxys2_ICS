#!/sbin/busybox sh

mount /dev/block/mmcblk0p11 /sdcard

if [ ! -f /sdcard/.hydra/efs-backup.tar.gz ];
then
  mkdir /mnt/sdcard/.hydra
  busybox tar zcvf /sdcard/.hydra/efs-backup.tar.gz /efs
fi

umount /sdcard

