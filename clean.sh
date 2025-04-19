#!/bin/sh

# This script cleans up the build directory and removes any temporary files created during the build process.
#
# check clean directory is exits and broadcom-wl-x.xx.tar.zst is exits
if [ -d "build" ]; then
    rm -rf build
fi
if [ -f "broadcom-wl-*.tar.zst" ]; then
    rm -f broadcom-wl-*.tar.zst
fi
