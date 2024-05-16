#!/bin/bash

# Function to display error messages and exit
function error_exit {
    echo "Error: $1" >&2
    exit 1
}

# Function to check command success
function check_command_success {
    if [ $? -ne 0 ]; then
        error_exit "$1 failed"
    fi
}

# Function to clone and build a repository
function clone_and_build {
    repo_url=$1
    repo_name=$(basename $repo_url .git)
    echo "Cloning $repo_name..."
    git clone $repo_url || error_exit "Cloning $repo_name"
    cd $repo_name || error_exit "Changing directory to $repo_name"
    echo "Building $repo_name..."
    autoreconf -fi || error_exit "Configuring $repo_name"
    ./configure || error_exit "Configuring $repo_name"
    make -j$(nproc) || error_exit "Building $repo_name"
    sudo make install || error_exit "Installing $repo_name"
    cd .. || error_exit "Changing directory to parent"
    echo "$repo_name installation and compilation completed successfully."
}

# Update package lists
echo "Updating package lists..."
sudo apt update || error_exit "Updating package lists"

# Install dependencies for Wireshark
echo "Installing Wireshark dependencies..."
sudo apt install -y wireshark || error_exit "Installing Wireshark dependencies"

# Install dependencies for SCTPScan
echo "Installing SCTPScan dependencies..."
sudo apt install -y sctp-utils || error_exit "Installing SCTPScan dependencies"

# Install dependencies for GNU Radio Companion
echo "Installing GNU Radio Companion dependencies..."
sudo apt install -y gnuradio gnuradio-dev || error_exit "Installing GNU Radio Companion dependencies"

# Install OpenSS7
echo "Installing OpenSS7..."
sudo apt install -y openss7 || error_exit "Installing OpenSS7"

# Install Asterisk with SS7 support
echo "Installing Asterisk with SS7 support..."
sudo apt install -y asterisk asterisk-ss7 || error_exit "Installing Asterisk with SS7 support"

# Clone and build other SS7 testing tools
echo "Installing other SS7 testing tools..."
clone_and_build "https://github.com/Telecominfraproject/wireshark.git"
clone_and_build "https://github.com/SignalingPlane/SCTPScan.git"
clone_and_build "https://github.com/alt236/SS7Tool.git"

echo "All installations and configurations completed successfully."
