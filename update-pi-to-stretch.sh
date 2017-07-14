#### Setup Pi ####

#Enable SSH
echo "" > /boot/ssh

#Upgrade the kernel and firmware
apt-get install rpi-update
rpi-update

#Restart chroot session
exit
sudo chroot . bin/bash

#Set apt source list to stretch
> /etc/apt/sources.list
echo "deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi" > /etc/apt/sources.list

#Upgrade to Stretch
apt-get update && yes | apt-get -q -y dist-upgrade

#Remove libnettle4:
apt-get -q -y remove libnettle4

#Autoremove all the uneeded packages:
apt -q -y autoremove

#Install the mesa driver
apt-get -q -y install libgl1-mesa-dri

#Get the driver for the onboard WLAN adapter from the RPi-Distro repo
wget -P /lib/firmware/brcm/ https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/master/brcm80211/brcm/brcmfmac43430-sdio.bin
wget -P /lib/firmware/brcm/ https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/master/brcm80211/brcm/brcmfmac43430-sdio.txt

#Change Qt’s default platform plugin to EGLFS
echo "export QT_QPA_PLATFORM=eglfs" >> ~/.profile