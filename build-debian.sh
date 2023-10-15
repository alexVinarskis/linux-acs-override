#!/bin/bash
ACSOPATCH_VER=6.3
KERNEL_VER=6.3
sudo apt install build-essential libncurses5-dev fakeroot xz-utils libelf-dev liblz4-tool \
  unzip flex bison bc debhelper rsync libssl-dev:native
wget -N https://github.com/torvalds/linux/archive/refs/tags/v$KERNEL_VER.zip
unzip -o v$KERNEL_VER.zip
cd linux-$KERNEL_VER
patch -p1 < ../$ACSOPATCH_VER/acso.patch
# Disable kernel signing
sudo make olddefconfig
sed -i 's|CONFIG_SYSTEM_REVOCATION_KEYS=".*"|CONFIG_SYSTEM_REVOCATION_KEYS=""|g' .config
sed -i 's|CONFIG_SYSTEM_TRUSTED_KEYS=".*"|CONFIG_SYSTEM_TRUSTED_KEYS=""|g' .config
sed -i 's|CONFIG_MODULE_SIG_ALL=y|CONFIG_MODULE_SIG_ALL=n|g' .config
sudo make -j $(nproc) bindeb-pkg LOCALVERSION=-acso KDEB_PKGVERSION=$(make kernelversion)-1
