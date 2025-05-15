# 🛠️ Android Image Kitchen (Linux) - Script Guide
A linux version of Android-Image-Kitchen

This document explains how to use the three core shell scripts for unpacking, modifying, and repacking Android boot images on Debian/Linux using a minimal Android Image Kitchen (AIK) setup.

---

## 📦 1. Installation: Required Dependencies

Before using any scripts, install the necessary tools:

```bash
sudo apt update && sudo apt install -y \
  android-sdk-libsparse-utils \
  android-sdk-platform-tools-common \
  cpio \
  gzip \
  lz4 \
  lzop \
  xz-utils \
  bzip2 \
  mkbootimg \
  findutils \
  coreutils \
  zip \
  unzip
```

---

## 🔓 2. `unpackimg.sh` – Unpack Boot Image

### 📄 Description
This script unpacks a standard Android `boot.img` into its components:
- Kernel (`split_img/`)
- Ramdisk (`ramdisk/`)

### 📥 Input
- A valid `boot.img` placed in the same directory.

### 📤 Output
- `split_img/` – Contains the kernel and metadata.
- `ramdisk/` – Contains extracted init scripts and config files.

### ▶️ Usage
```bash
./unpackimg.sh boot.img
```

If no filename is passed, the script attempts to auto-detect a suitable image in the directory.

---

## 🛠️ 3. `repackimg.sh` – Rebuild Boot Image

### 📄 Description
After making changes to the `ramdisk/` directory (e.g., modifying `init.rc`), this script will rebuild a new boot image using:
- Data from `split_img/`
- Files in `ramdisk/`

### 📥 Input
- `ramdisk/` and `split_img/` (output from `unpackimg.sh`)

### 📤 Output
- `image-new.img`

### ▶️ Usage
```bash
./repackimg.sh
```

---

## 🧹 4. `cleanup.sh` – Reset Workspace

### 📄 Description
Cleans up the working directory by removing:
- `ramdisk/`
- `split_img/`
- Any `*-new.*` files from a previous run

### ▶️ Usage
```bash
./cleanup.sh
```

---

## 📁 Suggested Folder Layout

```
Android-Image-Kitchen/
├── unpackimg.sh
├── repackimg.sh
├── cleanup.sh
├── boot.img               ← Place your boot image here
├── ramdisk/               ← Created automatically
├── split_img/             ← Created automatically
├── image-new.img          ← Output from repack
```

---

## ✅ Final Notes
- Ensure your device bootloader is unlocked before flashing modified images.
- These scripts are designed to operate within the same folder.
- Use `fastboot flash boot image-new.img` to install the modified boot image.
