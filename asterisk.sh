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
    git clone --recursive $repo_url || error_exit "Cloning $repo_name"
    cd $repo_name || error_exit "Changing directory to $repo_name"
    echo "Configuring $repo_name..."
    ./configure || error_exit "Configuring $repo_name"
    echo "Building $repo_name..."
    make -j$(nproc) || error_exit "Building $repo_name"
    sudo make install || error_exit "Installing $repo_name"
    cd .. || error_exit "Changing directory to parent"
    rm -rf $repo_name || error_exit "Removing $repo_name"
    echo "$repo_name installation and compilation completed successfully."
}

# Update package lists
echo "Updating package lists..."
sudo apt update || error_exit "Updating package lists"

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y git build-essential libssl-dev libncurses5-dev libnewt-dev libxml2-dev libsqlite3-dev libjansson-dev uuid-dev || error_exit "Installing dependencies"

# Clone and build Asterisk
echo "Downloading Asterisk..."
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz || error_exit "Downloading Asterisk source"
tar -zxvf asterisk-18-current.tar.gz || error_exit "Extracting Asterisk source"
cd asterisk-18.* || error_exit "Changing directory to Asterisk source"
echo "Configuring Asterisk..."
./configure || error_exit "Configuring Asterisk"
echo "Building Asterisk..."
make -j$(nproc) || error_exit "Building Asterisk"
sudo make install || error_exit "Installing Asterisk"
sudo make samples || error_exit "Installing Asterisk sample configuration"
sudo ldconfig || error_exit "Updating library cache"
cd .. || error_exit "Changing directory to parent"
rm -rf asterisk-* || error_exit "Removing Asterisk source"

echo "Asterisk installation and compilation completed successfully."
