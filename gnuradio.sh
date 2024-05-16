#!/bin/bash

# Update package lists
sudo apt update

# Install dependencies for GNU Radio
sudo apt install -y git cmake g++ libboost-all-dev libcppunit-dev swig doxygen liblog4cpp5-dev python3-numpy python3-mako python3-sphinx python3-lxml python3-lxml libfftw3-dev libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev liblog4cpp5-dev libzmq3-dev libusb-1.0-0 libpython3-dev python3-pyqt5 python3-pyqt5.qtsvg python3-click python3-click-plugins python3-zmq python3-scipy python3-gi python3-gi-cairo python3-lxml python3-gi python3-setuptools

# Clone GNU Radio repository
git clone --recursive https://github.com/gnuradio/gnuradio.git
cd gnuradio

# Build and install GNU Radio
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install
sudo ldconfig

# Go back to the home directory
cd ~

# Install dependencies for osmocom-bb and osmo-dev
sudo apt install -y libusb-1.0-0-dev libtalloc-dev libpcsclite-dev

# Clone osmocom-bb repository
git clone https://git.osmocom.org/osmocom-bb.git
cd osmocom-bb

# Build and install osmocom-bb
autoreconf -i
./configure
make -j$(nproc)
sudo make install

# Go back to the home directory
cd ~

# Clone osmo-dev repository
git clone git://git.osmocom.org/osmo-dev.git
cd osmo-dev

# Build and install osmo-dev
autoreconf -fi
./configure
make -j$(nproc)
sudo make install

# Clean up
cd ~
rm -rf gnuradio osmocom-bb osmo-dev

echo "Installation and compilation completed successfully."
