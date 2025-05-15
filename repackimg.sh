#!/bin/bash

# Android Image Kitchen - RepackImg Script (Linux)
# Converted by ChatGPT based on osm0sis' Windows .bat

set -e

echo "Android Image Kitchen - RepackImg Script"
echo "by osm0sis @ xda-developers"
echo

AIK="$(cd "$(dirname "$0")" && pwd)"
BIN="$AIK/android_win_tools"
OUT="image-new.img"

# Detect compression type
RAMDISK_COMP_FILE="$(find split_img -name '*-ramdiskcomp' | head -n1)"
RAMDISK_COMP="$(cat "$RAMDISK_COMP_FILE" 2>/dev/null || echo "gzip")"

if [ "$RAMDISK_COMP" == "empty" ]; then
  echo "Warning: ramdisk is marked empty. Using stub."
  touch ramdisk-new.cpio.empty
  RAMDISK="ramdisk-new.cpio.empty"
else
  echo "Packing new ramdisk with compression: $RAMDISK_COMP"
  cd ramdisk
  find . | cpio -o -H newc 2>/dev/null | gzip > ../ramdisk-new.cpio.gz
  cd ..
  RAMDISK="ramdisk-new.cpio.gz"
fi

# Locate kernel
KERNEL_FILE="$(find split_img -name '*-kernel' | head -n1)"
if [ ! -f "$KERNEL_FILE" ]; then
  echo "Error: kernel file not found in split_img/"
  exit 1
fi

# Locate other boot image properties
BASE=$(cat split_img/*-base 2>/dev/null || echo "0x10000000")
PAGESIZE=$(cat split_img/*-pagesize 2>/dev/null || echo "2048")
CMDLINE=$(cat split_img/*-cmdline 2>/dev/null || echo "")
BOARD=$(cat split_img/*-board 2>/dev/null || echo "")

# Repack boot image using mkbootimg
echo "Building new boot image..."
mkbootimg \
  --kernel "$KERNEL_FILE" \
  --ramdisk "$RAMDISK" \
  --cmdline "$CMDLINE" \
  --board "$BOARD" \
  --base "$BASE" \
  --pagesize "$PAGESIZE" \
  -o "$OUT"

echo "Done. Output: $OUT"
