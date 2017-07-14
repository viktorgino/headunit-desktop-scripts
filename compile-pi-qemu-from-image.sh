#Setup folder and get Raspbian Lite
rm -R ~/rpi_image
mkdir ~/rpi_image
cd ~/rpi_image
wget https://files.headunit.viktorgino.me/stretch_lite_with_headunit_latest.img

img_filename="stretch_lite_with_headunit_latest.img"

#Make a couple of loopback devices for the whole image and its partitions
loop_back_dev=$(sudo losetup -f -P --show $img_filename)

# Mount the image		
sudo mount $loop_back_dev"p2" -o rw ~/rpi_mnt
sudo mount $loop_back_dev"p1" -o rw ~/rpi_mnt/boot

#Take care of ~/rpi_mnt/etc/ld.so.preload
sudo mv ~/rpi_mnt/etc/ld.so.preload ~/rpi_mnt/etc/ld.so.preload.orig
echo "" | sudo tee -a  ~/rpi_mnt/etc/ld.so.preload

#Copy QemuUserEmulation binary to the chroot
sudo cp /usr/bin/qemu-arm-static ~/rpi_mnt/usr/bin

#chroot in
cd ~/rpi_mnt
sudo chroot . bin/bash

### Build headunit 
./compile-latest-master.sh

### Clean up
exit

#Restore ~/rpi_mnt/etc/ld.so.preload
sudo rm ~/rpi_mnt/etc/ld.so.preload
sudo mv ~/rpi_mnt/etc/ld.so.preload.orig ~/rpi_mnt/etc/ld.so.preload

#remove QemuUserEmulation binary from rpi root
sudo rm /usr/bin/qemu-arm-static

#Unmount
sudo umount ~/rpi_mnt
sudo umount ~/rpi_mnt/boot

#Remove loop devices
losetup -d /dev/loop0