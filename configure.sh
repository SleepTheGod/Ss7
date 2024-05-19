#!/bin/bash

# Function to configure and compile GNU Radio
configure_compile_gnuradio() {
    cd gnuradio
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install
    sudo ldconfig
    cd ../..
}

# Function to configure and compile libss7
configure_compile_libss7() {
    cd libss7
    ./configure
    make
    sudo make install
    cd ..
}

# Function to configure and compile osmocom-bb
configure_compile_osmocom_bb() {
    cd osmocom-bb
    autoreconf -i
    ./configure
    make
    cd ..
}

# Main script
configure_compile_gnuradio
configure_compile_libss7
configure_compile_osmocom_bb

# You can add similar functions for other projects if needed

echo "Compilation completed."
