#!/bin/bash
#
# Diese Script installiert die aktuelle Version
# von libva und Intel(R) Media Driver for VAAPI
# unter "/usr/local".
# Getestet unter Ubuntu 22.04 und Linux Mint 21.2
#
echo "Pakete installieren"
sudo apt update
sudo apt install build-essential git autoconf libtool libdrm-dev xorg xorg-dev openbox libx11-dev libgl1-mesa-glx libgl1-mesa-dev libx11-xcb-dev libxcb-dri3-dev libxext-dev libxfixes-dev libwayland-dev meson

mkdir $HOME/src
cd $HOME/src
echo "Erstelle libva"
git clone https://github.com/intel/libva.git
cd libva
./autogen.sh
make
sudo make install

cd $HOME/src
echo "Erstelle gmmlib"
git clone https://github.com/intel/gmmlib.git
cd gmmlib
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j"$(nproc)"
sudo make install

echo "Erstelle Intel(R) Media Driver for VAAPI"
cd $HOME/src
mkdir -p workdir/build_media
cd workdir
git clone https://github.com/intel/media-driver.git
cd $HOME/src
cd workdir/build_media
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=/usr/local/lib  -DBUILD_TYPE=release-internal ../media-driver
make -j"$(nproc)"
sudo make install
sudo ldconfig -v
