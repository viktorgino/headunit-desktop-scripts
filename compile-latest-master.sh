### Build headunit 
cd ~
if [ -d "headunit-desktop" ]; then
	cd headunit-desktop
	git pull
else
	git clone --recursive --depth 1 -j6 https://github.com/viktorgino/headunit-desktop.git
	cd headunit-desktop
fi
#Generate protobuf with proto
protoc --proto_path=headunit/hu/ --cpp_out=headunit/hu/generated.x64/ headunit/hu/hu.proto

#compile headunit-desktop
qmake
make -j4
