#!/usr/bin/env bash

# Setup environment variables
export PLATFORM_ROOT=$PWD
export WORKSPACE=$PLATFORM_ROOT/../../../..
export QEMU_ROOT=$WORKSPACE/qemu
export GCC5_AARCH64_PREFIX=/usr/bin/aarch64-linux-gnu-
export PACKAGES_PATH=$WORKSPACE/edk2:$WORKSPACE/edk2-platforms:$WORKSPACE/edk2-non-osi

# Apply necessary patches
cd $WORKSPACE/edk2-platforms
git apply --check $WORKSPACE/edk2-odp/Platform/Qemu/SbsaQemu/diffs/SbsaQemuHardwareInfoLib.diff && git apply $WORKSPACE/edk2-odp/Platform/Qemu/SbsaQemu/diffs/SbsaQemuHardwareInfoLib.diff

make -C $WORKSPACE/edk2/BaseTools
source $WORKSPACE/edk2/edksetup.sh

# Build QEMU
cd $QEMU_ROOT
./configure --target-list=aarch64-softmmu --enable-gtk
ninja -C build

# Build TF-A images
cd $WORKSPACE/trusted-firmware-a
make PLAT=qemu_sbsa all fip
cp build/qemu_sbsa/release/bl1.bin $WORKSPACE/edk2-non-osi/Platform/Qemu/Sbsa/
cp build/qemu_sbsa/release/fip.bin $WORKSPACE/edk2-non-osi/Platform/Qemu/Sbsa/

# Regenerate UEFI SBSA image
build -b DEBUG -a AARCH64 -t GCC5 -p $WORKSPACE/edk2-platforms/Platform/Qemu/SbsaQemu/SbsaQemu.dsc

# Post-build: Prepare output directory and flash files
mkdir -p $PLATFORM_ROOT/output
cp $WORKSPACE/Build/SbsaQemu/DEBUG_GCC5/FV/SBSA_FLASH[01].fd $PLATFORM_ROOT/output/
truncate -s 256M $PLATFORM_ROOT/output/SBSA_FLASH[01].fd

# Run QEMU
$QEMU_ROOT/build/qemu-system-aarch64 -machine sbsa-ref -cpu max -m 4G -drive if=pflash,format=raw,file=$PLATFORM_ROOT/output/SBSA_FLASH0.fd -drive if=pflash,format=raw,file=$PLATFORM_ROOT/output/SBSA_FLASH1.fd -serial stdio