#!/usr/bin/env bash

# usage
# sed -e "s/__DISK__/sdz/g" -e "s/exit//g" cleanup.sh | ssh s8s-192-168-2-220 'sudo bash -s'

exit

DISK="/dev/__DISK__"

# Zap the disk to a fresh, usable state (zap-all is important, b/c MBR has to be clean)

# You will have to run this step for all disks.
sgdisk --zap-all $DISK

# Clean hdds with dd
dd if=/dev/zero of="$DISK" bs=1M count=100 oflag=direct,dsync

# These steps only have to be run once on each node
# If rook sets up osds using ceph-volume, teardown leaves some devices mapped that lock the disks.
ls /dev/mapper/ceph-* | xargs -I% -- dmsetup remove %

# ceph-volume setup can leave ceph-<UUID> directories in /dev and /dev/mapper (unnecessary clutter)
rm -rf /dev/ceph-* | true
rm -rf /dev/mapper/ceph--* | true

# delete dataDirHostPath
rm -rf /var/lib/rook | true
