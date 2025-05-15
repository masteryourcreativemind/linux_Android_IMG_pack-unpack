#!/bin/bash

# Android Image Kitchen - UnpackImg Script (Linux Version)
# Converted from .bat by ChatGPT
# by osm0sis @ xda-developers

echo "Android Image Kitchen - UnpackImg Script"
echo "by osm0sis @ xda-developers"
echo

# Helper vars
AIK="$(cd "$(dirname "$0")" && pwd)"
BIN="$AIK/android_win_tools"
CURDIR="$PWD"

# Help message
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [--local] <file>"
    exit 1
fi

# Optional --local flag
if [[ "$1" == "--local" ]]; then
    LOCAL="--local"
    shift
fi

# Find input image
if [[ -z "$1" ]]; then
    for f in *.elf *.img *.sin; do
        case "$f" in
        aboot.img | image-new.img | unlokied-new.img | unsigned-new.img) continue ;;
        *)
            IMG="$f"
            break
            ;;
        esac
    done
else
    IMG="$1"
fi

# Validation
if [[ -z "$IMG" || ! -f "$IMG" ]]; then
    echo "No valid image file supplied or found!"
    exit 1
fi

IMG="$(realpath "$IMG")"
echo "Supplied image: $(basename "$IMG")"
echo

# Clean up old unpack
[[ -d split_img ]] && rm -rf split_img
[[ -d ramdisk ]] && rm -rf ramdisk

mkdir -p split_img ramdisk

# Extract image (using included bin tools)
"$BIN/unpackbootimg" -i "$IMG" -o split_img/

# Extract ramdisk if present
if [[ -f split_img/*-ramdisk.gz ]]; then
    RAMDISK="$(ls split_img/*-ramdisk.gz)"
    echo "Unpacking ramdisk: $RAMDISK"
    mkdir -p ramdisk
    cd ramdisk
    gzip -dc "../$RAMDISK" | cpio -idm
    cd ..
fi

echo "Done unpacking."
