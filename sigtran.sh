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

# Install dependencies for SIGTRAN
echo "Installing SIGTRAN dependencies..."
sudo apt install -y libssl-dev || error_exit "Installing SIGTRAN dependencies"

# Install and configure OpenSS7
echo "Installing and configuring OpenSS7..."
sudo apt install -y openss7 || error_exit "Installing OpenSS7"
sudo sed -i 's/^#netlink.*$/netlink yes/' /etc/ss7/ss7.conf || error_exit "Configuring OpenSS7"
sudo systemctl restart openss7 || error_exit "Restarting OpenSS7"

# Install and configure SCTPScan
echo "Installing and configuring SCTPScan..."
clone_and_build "https://github.com/SignalingPlane/SCTPScan.git"

echo "SIGTRAN adaptation setup completed successfully."
