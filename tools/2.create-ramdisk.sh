#!/bin/bash
set -evx
echo "Creating ramdisk.."

LOOP_DIR=$(pwd)/$LOOP
RAMDISK=$(pwd)/ramdisk

# Create yet another loop device if not exist
[ -e $LOOP ] || mknod $LOOP b 7 0

# create ramdisk file of IMAGE_SIZE
dd if=/dev/zero of=$RAMDISK bs=1k count=$IMAGE_SIZE

# plug off any virtual fs from loop device
losetup -d $LOOP || true

# associate it with ${LOOP}
losetup $LOOP $RAMDISK

# make an ext2 filesystem
mkfs.ext4 -q -m 0 $LOOP $IMAGE_SIZE
#mke2fs $LOOP

# ensure loop2 directory
[ -d $LOOP_DIR ] || mkdir -pv $LOOP_DIR

# mount it
mount $LOOP $LOOP_DIR
rm -rf $LOOP_DIR/lost+found

# copy LFS system without build artifacts
pushd $INITRD_TREE
cp -dpR $(ls -A | grep -Ev "sources|tools|jhalfs") $LOOP_DIR
popd

# show statistics
df $LOOP_DIR

echo "Compressing system ramdisk image.."
pushd $LOOP_DIR 
find . -print0 | cpio --null -ov --format=newc \
  | gzip -9 > /tmp/rootfs.cpio
popd

# Copy compressed image to /tmp dir (need for dockerhub)
#cp -v $IMAGE .

# Cleanup
#umount $LOOP_DIR
#losetup -d $LOOP
#rm -rf $LOOP_DIR
#rm -f $RAMDISK
