### Build and install QtGstreamer ###

cd /home/pi

#Clone QtGstreamer
git clone git://anongit.freedesktop.org/gstreamer/qt-gstreamer
cd qt-gstreamer

#Create build dir:
mkdir build && cd build

#cmake QtGstreamer
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) -DCMAKE_INSTALL_INCLUDEDIR=include -DQT_VERSION=5 -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++11

#Make and install QtGstreamer
make -j6
sudo make install