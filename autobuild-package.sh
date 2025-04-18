#!/bin/sh

# This script builds the package from the source code.

cd build/usr/src/broadcom-wl-6.30.223.271

# Build the package
make clean && make CC=clang LD=ld.lld --silent

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Build failed."
    exit 1
fi

# Package the built files
cd -

cd build

# Install the package
mkdir -p usr/lib/modules/$(uname -r)/kernel/drivers/net/wireless/broadcom/
cp -r usr/src/broadcom-wl-6.30.223.271/wl.ko usr/lib/modules/$(uname -r)/kernel/drivers/net/wireless/broadcom/

# Package the built files:
# Tar the files in usr/lib usr/share, exclude the source code

# Get linux version from uname -r in x.xx format
version=$(uname -r | cut -d '.' -f 1-2)

tar -I zstd -cf ../broadcom-wl-$version.tar.zst --exclude=src -C usr .
# Check if the package was created successfully
if [ $? -ne 0 ]; then
    echo "Failed to create the package."
    exit 1
fi

cd ..
