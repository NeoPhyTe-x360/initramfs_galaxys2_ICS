#!/sbin/busybox sh
# Almost all tweaks modified by NeoPhyTe.x360
# also thanks to:
#    gokhanmoral profiles
#          thanks to hardcore and nexxx
#                 thanks to pikachu01@XDA
# some parameters are taken from http://forum.xda-developers.com/showthread.php?t=1292743 (highly recommended to read)


. /res/customconfig/customconfig-helper
read_defaults
read_config

#apply default config, delay for 5 secs to make sure that everything is initialized
(
sleep 1
/res/uci.sh apply
) &

/system/bin/starting &
sleep 8
# CPU Tweaks
echo "lulzactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# echo "87000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
# echo "80" > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
sleep 12

# Iwconfig binary and Wireless improvings
mount -o rw,remount /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs
/sbin/busybox cp /sbin/iwconfig /system/xbin/iwconfig
/sbin/busybox cp /sbin/95-configured /system/etc/dhcpcd/dhcpcd-hooks/95-configured
chown 0.0 /system/xbin/iwconfig
chmod 6755 /system/xbin/iwconfig
chown 0.0 /system/etc/dhcpcd/dhcpcd-hooks/95-configured
chmod 6755 /system/etc/dhcpcd/dhcpcd-hooks/95-configured
mount -t rootfs -o remount,ro rootfs



# CPU Tweaks
echo "lulzactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# echo "87000" > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
# echo "80" > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold


# Core Powersaving tweaks- SCHED_MC  -  AFTR
echo "1" > /sys/devices/system/cpu/sched_mc_power_savings   # applied in profiles
echo "3" > /sys/module/cpuidle/parameters/enable_mask


# CFS Scheduler Tweaks
umount /sys/kernel/debug
mount -t debugfs none /sys/kernel/debug
echo NO_GENTLE_FAIR_SLEEPERS > /sys/kernel/debug/sched_features
echo NO_START_DEBIT > /sys/kernel/debug/sched_features
echo NO_WAKEUP_PREEMPT > /sys/kernel/debug/sched_features
echo NEXT_BUDDY > /sys/kernel/debug/sched_features
echo NO_ARCH_POWER > /sys/kernel/debug/sched_features
echo HRTICK > /sys/kernel/debug/sched_features
echo "600000" > /proc/sys/kernel/sched_latency_ns
echo "400000" > /proc/sys/kernel/sched_min_granularity_ns
echo "76000" > /proc/sys/kernel/sched_wakeup_granularity_ns
umount /sys/kernel/debug


# Toushcreen sensitivity tweak
echo "20" > /sys/devices/virtual/sec/sec_touchscreen/tsp_threshold
echo "2" > /sys/devices/platform/s3c2440-i2c.3/i2c-3/3-004a/mov_hysti


# IPv6 privacy tweak
echo "2" > /proc/sys/net/ipv6/conf/all/use_tempaddr


# TCP tweaks
echo "4096 16384 404480" > /proc/sys/net/ipv4/tcp_wmem
echo "4096 87380 404480" > /proc/sys/net/ipv4/tcp_rmem
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "110208" > /proc/sys/net/core/rmem_default
echo "404480" > /proc/sys/net/core/rmem_max
echo "110208" > /proc/sys/net/core/wmem_default
echo "404480" > /proc/sys/net/core/wmem_max
echo "0" > /proc/sys/net/ipv4/tcp_timestamps 
echo "1" > /proc/sys/net/ipv4/tcp_sack 
echo "1" > /proc/sys/net/ipv4/tcp_window_scaling
echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout
echo "120" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle
echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse
echo "256" > /proc/sys/net/ipv4/neigh/default/gc_thresh1
echo "1024" > /proc/sys/net/ipv4/neigh/default/gc_thresh2
echo "2048" > /proc/sys/net/ipv4/neigh/default/gc_thresh3
echo "1024" > /proc/sys/net/ipv4/tcp_max_orphans
echo "1" > /proc/sys/net/ipv4/tcp_abort_on_overflow


# disable debugging on some modules
if [ "$logger" == "off" ];then
  echo 0 > /sys/module/ump/parameters/ump_debug_level
  echo 0 > /sys/module/mali/parameters/mali_debug_level
  echo 0 > /sys/module/kernel/parameters/initcall_debug
  echo 0 > /sys/module/lowmemorykiller/parameters/debug_level
  echo 0 > /sys/module/wakelock/parameters/debug_mask
  echo 0 > /sys/module/userwakelock/parameters/debug_mask
  echo 0 > /sys/module/earlysuspend/parameters/debug_mask
  echo 0 > /sys/module/alarm/parameters/debug_mask
  echo 0 > /sys/module/alarm_dev/parameters/debug_mask
  echo 0 > /sys/module/binder/parameters/debug_mask
  echo 0 > /sys/module/xt_qtaguid/parameters/debug_mask
fi



# IO Block Tweaks
STL=`ls -d /sys/block/stl*`;
BML=`ls -d /sys/block/bml*`;
MMC0=/sys/block/mmcblk0;
MMC1=/sys/block/mmcblk1;
ZRM=`ls -d /sys/block/zram*`;
MTD=`ls -d /sys/block/mtd*`;
 
for i in $STL $BML $MMC0 $MMC1 $ZRM $MTD;
do
		echo "sio" > $MMC1/queue/scheduler;
		echo "0" > $i/queue/rotational; 
		# echo "256" > $i/queue/nr_requests; 
		# echo "512" > $i/queue/max_sectors_kb;
		echo "1" > $i/queue/iosched/back_seek_penalty;
		echo "1" > $i/queue/iosched/low_latency;
		echo "32768" > $i/queue/iosched/back_seek_max;
		echo "0" > $i/queue/iosched/slice_idle; 
		echo "32" > $i/queue/iosched/quantum;
		echo "4" > $i/queue/iosched/slice_async_rq;
		echo "1024" > $i/queue/iosched/fifo_expire_sync;
		echo "1024" > $i/queue/iosched/fifo_expire_async;
		echo "40" > $i/queue/iosched/slice_sync;
		echo "40" > $i/queue/iosched/slice_async;
		echo "1" > $i/queue/iosched/rev_penalty;
		echo "1" > $i/queue/rq_affinity;   
		echo "0" > $i/queue/iostats;
		echo "512" > $i/queue/read_ahead_kb;
		# echo "0"   >  $i/queue/nomerges;
		# echo "128" >  $i/queue/max_sectors_kb;
		echo "2500" > $i/queue/iosched/async_read_expire;
		echo "250" > $i/queue/iosched/sync_read_expire;
		echo "2500" > $i/queue/iosched/async_expire;
		echo "250" > $i/queue/iosched/sync_expire;
		echo "2" > $i/queue/iosched/fifo_batch;
		echo "2500" > $i/queue/iosched/async_write_expire;
		echo "250" > $i/queue/iosched/sync_write_expire;
		echo "256" > $i/queue/nr_requests; 
		echo "512" > $i/queue/read_ahead_kb;
done;

# Setting readahead kb
if [ -e /sys/devices/virtual/bdi/179:0/read_ahead_kb ];
then
    echo "512" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;
fi;
	
if [ -e /sys/devices/virtual/bdi/179:8/read_ahead_kb ];
  then
    echo "512" > /sys/devices/virtual/bdi/179:8/read_ahead_kb;
fi;

if [ -e /sys/devices/virtual/bdi/179:16/read_ahead_kb ];
  then
    echo "512" > /sys/devices/virtual/bdi/179:16/read_ahead_kb;
fi;

if [ -e /sys/devices/virtual/bdi/179:24/read_ahead_kb ];
  then
    echo "512" > /sys/devices/virtual/bdi/179:28/read_ahead_kb;
fi;

if [ -e /sys/devices/virtual/bdi/default/read_ahead_kb ];
  then
    echo "256" > /sys/devices/virtual/bdi/default/read_ahead_kb;
fi;


# BATTERY-TWEAKS
for i in $(ls /sys/bus/usb/devices/*/power/level);
do 
	echo "auto" > $i;
done



# Enable zRam
if [ -e /dev/block/zram0 ]; then
	# Setting swappines
	echo 10 > /proc/sys/vm/swappiness 
	# Setting size of each ZRAM swap drives
	echo 100000000 > /sys/block/zram0/disksize
	echo 100000000 > /sys/block/zram1/disksize
	echo 100000000 > /sys/block/zram2/disksize
	# Creating SWAPS from ZRAM drives
	mkswap /dev/block/zram0 >/dev/null
	mkswap /dev/block/zram1 >/dev/null
	mkswap /dev/block/zram2 >/dev/null
	# Activating ZRAM swaps with the same priority to load balance ram swapping (need advanced busybox with swapon -p flag)
	swapon /dev/block/zram0 -p 20 >/dev/null 2>&1
	swapon /dev/block/zram1 -p 20 >/dev/null 2>&1
	swapon /dev/block/zram2 -p 20 >/dev/null 2>&1
	# Show to user that swap is ON
	free
fi


# Remount all partitions with noatime
/sbin/busybox mount rootfs -o remount,ro rootfs
mount -o remount,rw,noatime,nodiratime,nodev,nobh,nouser_xattr,inode_readahead_blks=0,discard,commit=60,noauto_da_alloc,delalloc /cache /cache;
mount -o remount,rw,noatime,nodiratime,nodev,nobh,nouser_xattr,inode_readahead_blks=0,discard,commit=60,noauto_da_alloc,delalloc /data /data;
mount -o remount,rw,noatime,nodiratime /system /system

# Other tweaks
/sbin/busybox sh /sbin/ext/smoothsystem.sh &   
# /sbin/busybox sh /sbin/ext/thundtweaks2.sh   # Dont run this tweaks 4 the moment


# Enable Voodoo Louder debugfs
mount -t debugfs none /sys/kernel/debug


# Mount external sd and usbstorage in sdcard
#sleep 20
#/sbin/busybox mount /dev/block/mmcblk0p11 /sdcard
#mkdir /mnt/sdcard/external_sd
#umount /sdcard
#mkdir /mnt/sdcard/usbStorage
#/sbin/busybox mount -o bind /mnt/emmc /mnt/sdcard/external_sd
#mount /mnt/usbdisk /mnt/sdcard/usbStorage


