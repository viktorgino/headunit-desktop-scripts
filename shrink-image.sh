sudo umount ~/rpi_mnt/boot
sudo umount ~/rpi_mnt

sudo e2fsck $loop_back_dev"p2"

total_space=$(stat -f  $loop_back_dev"p2"  --format="%b")
free_space=$(stat -f  $loop_back_dev"p2"  --format="%f")

sudo resize2fs -M $loop_back_dev"p2"


sudo apt-get install zip
zip rpi-hu.zip 2017-06-21-raspbian-jessie-lite.img