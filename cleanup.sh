#!/bin/bash

# Android Image Kitchen - Cleanup Script (Linux)
# Converted by ChatGPT

echo "Android Image Kitchen - Cleanup Script"
echo

BIN="$(cd "$(dirname "$0")" && pwd)/android_win_tools"

# Display help if requested
if [[ "$1" == "--help" ]]; then
    echo "Usage: $0 [--local]"
    exit 0
fi

# Ensure write permissions before attempting deletion
chmod -Rf +rw ramdisk split_img 2>/dev/null

# Remove directories
rm -rf ramdisk split_img 2>/dev/null

# Delete all *new.* files (e.g., image-new.img, ramdisk-new.cpio.gz, etc.)
rm -f *new.* 2>/dev/null

echo "Working directory cleaned."
