#!/sbin/busybox sh
#
# 89system_tweak V66
# by zacharias.maladroit
# modifications and ideas taken from: ckMod SSSwitch by voku1987 and "battery tweak" (collin_ph@xda)
# OOM/LMK settings by Juwe11
# network security settings inspired by various security, server guides on the web
# some modifications more by NeoPhyTe.x360

# Other VM and memory tweaks
echo "0,1,2,7,14,15" > /sys/module/lowmemorykiller/parameters/adj
echo "8192,10240,12288,21000,23000,25000" > /sys/module/lowmemorykiller/parameters/minfree
echo "20" > /proc/sys/vm/dirty_ratio
echo "10" > /proc/sys/vm/dirty_background_ratio
echo "80" > /proc/sys/vm/vfs_cache_pressure
echo "4" > /proc/sys/vm/min_free_order_shift
#echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
#echo "64" > /sys/module/lowmemorykiller/parameters/cost
#echo "128 40" > /proc/sys/vm/lowmem_reserve_ratio
echo "4" > /proc/sys/vm/min_free_order_shift
echo "1" > /proc/sys/vm/oom_kill_allocating_task
echo "1" > /proc/sys/vm/panic_on_oom
echo "1" > /proc/sys/vm/overcommit_memory
echo "5" > /proc/sys/vm/laptop_mode
#echo "100" > /proc/sys/vm/overcommit_ratio
#echo "3" > /proc/sys/vm/page-cluster
#echo "10" > /proc/sys/fs/lease-break-time
#echo "300" > /proc/sys/vm/stat_interval
echo "0" > /proc/sys/vm/swapiness
echo "4096" > /proc/sys/vm/min_free_kbytes
#echo "-16" > /proc/1/oom_adj
#echo "-17" > /proc/`pidof android.process.acore`/oom_adj
#echo "-15" > /proc/`pidof com.android.phone`/oom_adj
#echo "-14" > /proc/`pidof com.android.systemui`/oom_adj


# UI tweaks
setprop debug.performance.tuning 1; 
setprop video.accelerate.hw 1;
setprop debug.sf.hw 1;
setprop windowsmgr.max_events_per_sec 90;


# Unlimiting processes and open files for system
#ulimit -n 20480
#ulimit -s unlimited


# Powering the SYSTEM and Sdcard
#chrt -r -p 80 `pidof mmcqd`
#chrt -r -p 80 `pidof flush-179:0`
#chrt -r -p 80 `pidof flush-179:16`
#renice -17 `pidof mmcqd`
#renice -17 `pidof flush-179:0`
#renice -17 `pidof flush-179:16`
#renice 19 `pidof kswapd0`
#ionice `pidof mmcqd` rt 2
#ionice `pidof flush-179:0` rt 2
#ionice `pidof flush-179:16` rt 2
#ionice `pidof com.android.phone` rt 2

# sqlite3 and Database files Vacuum tweak
mount -o rw,remount /dev/block/mmcblk0p9 /system
/sbin/busybox mount rootfs / -o remount,rw
/sbin/busybox cp /sbin/sqlite3 /system/xbin/sqlite3
chown 0.0 /system/xbin/sqlite3
chmod 6755 /system/xbin/sqlite3
mount -o remount,ro /system
mount -t rootfs -o remount,ro rootfs

SQLITE3=/system/xbin/sqlite3

/sbin/busybox mount -o remount,rw /
for i in `find /data -iname "*.db"`;   do
     $SQLITE3 $i 'VACUUM;';
     $SQLITE3 $i 'PRAGMA journal_mode = WAL;'; 
     $SQLITE3 $i 'PRAGMA temp_store = MEMORY;';  
     $SQLITE3 $i 'PRAGMA count_changes = OFF;';  
     $SQLITE3 $i 'PRAGMA synchronous = OFF;';  
     $SQLITE3 $i 'PRAGMA auto_vacuum = FULL;';  
     $SQLITE3 $i 'PRAGMA wal_autocheckpoint = 0;';   
done;
 
for i in `find /dbdata -iname "*.db"`;   do
    $SQLITE3 $i 'VACUUM;';
    $SQLITE3 $i 'PRAGMA journal_mode = WAL;'; 
    $SQLITE3 $i 'PRAGMA temp_store = MEMORY;';  
    $SQLITE3 $i 'PRAGMA count_changes = OFF;';  
    $SQLITE3 $i 'PRAGMA synchronous = OFF;';  
    $SQLITE3 $i 'PRAGMA auto_vacuum = FULL;';  
    $SQLITE3 $i 'PRAGMA wal_autocheckpoint = 0;';   
done;
 
for i in `find /sdcard -iname "*.db"`;   do
     $SQLITE3 $i 'VACUUM;';
     $SQLITE3 $i 'PRAGMA journal_mode = WAL;'; 
     $SQLITE3 $i 'PRAGMA temp_store = MEMORY;';  
     $SQLITE3 $i 'PRAGMA count_changes = OFF;';  
     $SQLITE3 $i 'PRAGMA synchronous = OFF;';  
     $SQLITE3 $i 'PRAGMA auto_vacuum = FULL;';  
     $SQLITE3 $i 'PRAGMA wal_autocheckpoint = 0;';   
done;
/sbin/busybox mount -o remount,ro /



# Remount all partitions with noatime
for k in $(busybox mount | grep relatime | cut -d " " -f3);
do
#sync;
busybox mount -o remount,noatime $k;
done;

