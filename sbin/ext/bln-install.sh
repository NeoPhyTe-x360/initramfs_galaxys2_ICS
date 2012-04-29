#!/sbin/busybox sh 
# Installing BLN modded liblights
# thx to GM

/sbin/busybox mount -o remount,rw /system
    
    /sbin/busybox rm /system/lib/lights.exynos4.so
    /sbin/busybox rm /system/lib/hw/lights.exynos4.so
    /sbin/busybox cp /res/misc/lights.exynos4.so /system/lib/hw
    /sbin/busybox cp /res/misc/lights.exynos4.so /system/lib
    /sbin/busybox chown 0.0 /system/lib/hw/lights.exynos4.so
    /sbin/busybox chmod 644 /system/lib/hw/lights.exynos4.so
    /sbin/busybox chown 0.0 /system/lib/lights.exynos4.so
    /sbin/busybox chmod 644 /system/lib/lights.exynos4.so
