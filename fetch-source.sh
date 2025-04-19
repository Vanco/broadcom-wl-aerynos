#!/bin/sh

# This script fetches the source code for a given version of a package.
#
# Usage:
# ./fetch-source.sh <version>

# check parameters
# Check if the version argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

# Check if the build directory exists
# If not, create it, else clean it
if [ ! -d "build" ]; then
    mkdir build
else
    rm -rf build/*
fi
cd build

# Check mirrors of archlinux, select local mirror
# For example, for China:
#
# https://mirrors.ustc.edu.cn/archlinux/
curl -L -o package.tar.zst "https://mirrors.ustc.edu.cn/archlinux/extra/os/x86_64/broadcom-wl-dkms-$1-x86_64.pkg.tar.zst"
if [ $? -ne 0 ]; then
    echo "Failed to download the package."
    exit 1
fi

# Extract the downloaded package
# The package is in zst format, so we need to use the appropriate tool to extract it.
    # Check if zstd is installed
    # If not, install it
    # For example, for moss:
    # sudo moss install zstd

    tar -I zstd -xf package.tar.zst

# Find Makefile in /build/src/ and replace EXTRA_FLAGS := /usr/lib with EXTRA_FLAGS := ../../lib  in Makefile
    find . -name "Makefile" -exec sed -i 's|/usr/lib|../../lib|' {} \;
