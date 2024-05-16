#!/bin/bash

# Clone the libedit repository
git clone https://salsa.debian.org/debian/libedit.git
cd libedit

# Install build dependencies
sudo apt-get update
sudo apt-get install build-essential autoconf automake libtool

# Run autogen script
./autogen.sh

# Configure libedit
./configure

# Compile libedit
make

# Install libedit
sudo make install

# Clean up
cd ..
rm -rf libedit
