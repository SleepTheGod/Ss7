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
    echo "Configuring $repo_name..."
    ./configure || error_exit "Configuring $repo_name"
    echo "Building $repo_name..."
    make -j$(nproc) || error_exit "Building $repo_name"
    sudo make install || error_exit "Installing $repo_name"
    cd .. || error_exit "Changing directory to parent"
    echo "$repo_name installation and compilation completed successfully."
}

# Update package lists
echo "Updating package lists..."
sudo apt update || error_exit "Updating package lists"

# Clone and build osmo-dev
clone_and_build "https://git.osmocom.org/osmo-dev"

# Install build dependencies
echo "Installing build dependencies..."
sudo apt install -y build-essential git libtool shtool autoconf automake make gcc g++ libpcsclite-dev libtalloc-dev libortp-dev || error_exit "Installing build dependencies"

# Install additional dependencies
echo "Installing additional dependencies..."
sudo apt install -y libsctp-dev libmnl-dev libdbi-dev libdbd-sqlite3 libsqlite3-dev || error_exit "Installing additional dependencies"
sudo apt install -y libgnutls28-dev libssl-dev libosmocore-dev libosmo-abis-dev libosmo-netif-dev libosmo-sccp-dev libsmpp34-dev || error_exit "Installing additional dependencies"
sudo apt install -y libasn1c-dev libgtpnl-dev libusrp-dev libdbd-mysql libmariadb-dev libmariadb-dev-compat || error_exit "Installing additional dependencies"

# Install Osmocom components
echo "Installing Osmocom components..."
sudo apt install -y osmo-mgw osmo-msc osmo-hlr osmo-ggsn osmo-sgsn osmo-stp osmo-bsc osmo-bts || error_exit "Installing Osmocom components"

# Clone and build libss7
clone_and_build "https://github.com/asterisk/libss7"

echo "Installation, compilation, and configuration completed successfully."
