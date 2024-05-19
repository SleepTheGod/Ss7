#!/bin/bash

set -e

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Update system and install required packages
echo "Updating system and installing required packages..."
apt update
apt upgrade -y
apt install -y build-essential libssl-dev libpcap-dev git autoconf automake libtool wget

# Step 1: Install Required Dependencies
echo "Installing dependencies..."
# Add any additional dependencies as needed

# Step 2: Install Osmocom SS7 Stack
echo "Installing Osmocom SS7 stack..."
git clone git://git.osmocom.org/libosmocore.git
cd libosmocore
autoreconf -fi
./configure
make
make install
ldconfig
cd ..

git clone git://git.osmocom.org/libosmo-sccp.git
cd libosmo-sccp
autoreconf -fi
./configure
make
make install
ldconfig
cd ..

git clone git://git.osmocom.org/osmo-mgw.git
cd osmo-mgw
autoreconf -fi
./configure
make
make install
ldconfig
cd ..

# Step 3: Install Attack and Defense Scripts
echo "Downloading and installing SS7 attack and defense scripts..."
git clone https://github.com/ernw/ss7MAPer.git
cd ss7MAPer
make
cd ..

# Step 4: Install RTL-SDR Scripts
echo "Installing RTL-SDR scripts..."
# You can add installation steps for RTL-SDR scripts here if needed

# Step 5: Install TTCN-3 Scripts
echo "Installing TTCN-3 scripts..."
# You can add installation steps for TTCN-3 scripts here if needed

echo "Installation completed successfully."
