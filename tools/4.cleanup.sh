#!/bin/bash
set -x
echo "Clean ramdisk.."
LOOP_DIR=$(pwd)/$LOOP
RAMDISK=$(pwd)/ramdisk

# Cleanup

umount $LOOP_DIR
losetup -d $LOOP
rm -rf $LOOP_DIR
rm -f $RAMDISK
