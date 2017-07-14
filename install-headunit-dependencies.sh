#Install Qt5
apt-get -q -y install qt5-default qml-module-qtquick2 qtdeclarative5-dev qtmultimedia5-dev libqt5multimedia5-plugins qml-module-qtquick* qml-module-qtmultimedia qml-module-qt-labs-settings qml-module-qt-labs-folderlistmodel

#Install the neccesarry build tools
apt-get -q -y install build-essential cmake protobuf-compiler

#Install all the other dependencies
apt-get -q -y install libusb-1.0-0-dev libssl-dev openssl libglib2.0-dev libgstreamer1.0-dev gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-alsa libboost-dev libgstreamer-plugins-base1.0-dev libudev-dev libtag1-dev libprotobuf-dev libunwind-dev

#Install Git
apt-get -q -y install git

#Change device permission all known Android vendors 
wget -P /etc/udev/rules.d https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules