#Install needed packages
sudo apt-get install qemu qemu-user-static binfmt-support

#Setup folder and get Raspbian Lite
mkdir ~/rpi_image
cd ~/rpi_image
wget https://downloads.raspberrypi.org/raspbian_lite_latest

#Unzip and clean up
unzip raspbian_lite_latest
#rm raspbian_lite_latest

#Get the name of the img file
pattern="*raspbian-jessie-lite.img"
files=( $pattern )
img_filename="${files[0]}"

#Calculate roughly how much space to add
img_filesize=$(($(stat --printf="%s" $img_filename)/1000000))
space_needed=$((7168-img_filesize))
#Calculate the last block of the img file
partition_end=$(sudo parted $loop_back_dev print -s |awk {'print $3'} | awk '/./{line=$0} END{print line}')
sanitised_p_e=${partition_end%MB}
#Add space to the image
dd if=/dev/zero bs=1M count=$space_needed >> $img_filename

#Make a couple of loopback devices for the whole image and its partitions
loop_back_dev=$(sudo losetup -f -P --show $img_filename)

#Remove the second partition, resize it to be the full size of /dev/loop0
sudo parted $loop_back_dev resizepart 2 $sanitised_p_e

#Check and resize the new partition
sudo e2fsck -f $loop_back_dev"p2"
sudo resize2fs $loop_back_dev"p2"

# Mount the image		
sudo mkdir ~/rpi_mnt
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

#### Setup Pi ####
./update-pi-to-stretch.sh

#Restart chroot session
exit
sudo chroot . bin/bash

./install-headunit-dependencies.sh

### Build and install QtGstreamer ###
./compile-latest-qtgstreamer.sh

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
sudo losetup -d /dev/loop0