#!/bin/bash
#
# Script for setup a build environment for Raspberry Pi.
#
# updated 2022 bullseye apocsantos
# Original credits to:
# Author:
#     Sergio Conde <skgsergio@gmail.com>
#     https://github.com/skgsergio/rpi-buildenv
#

. aux.inc.sh

RASPBIAN_MIRROR="http://archive.raspbian.org"
#RASPBIAN_MIRROR="http://raspbian.sconde.net"
RASPBIAN_VERSION="bullseye"  # jessie #bullseye


chk_dep() {
    if [[ $($cmd_sudo which $1) == "" ]]; then
        echo "[ERR] $1 not found."

        if [[ $2 != "-" ]]; then
            echo -e "\nIf you are using Debian, Ubuntu, Mint or any other apt/deb based distribution you can install it using: apt-get install $2"
        fi

        exit 1
    else
        echo "[ OK] $1 found."
    fi
}

print_msg "Checking for dependencies...\n"

chk_dep debootstrap debootstrap
chk_dep qemu-debootstrap qemu-user-static
chk_dep chroot coreutils

debootstrap --components=main,restricted,universe --include=lxc bullseye rootfs


print_msg "Downloading Raspbian rootfs...\n"

$cmd_sudo debootstrap --no-check-gpg --include=ca-certificates,git-core,binutils,curl --arch armhf $RASPBIAN_VERSION $rootfs_dir $RASPBIAN_MIRROR/raspbian/

print_msg "Configuring rootfs...\n"

cat <<EOF | $cmd_sudo tee $rootfs_dir/usr/sbin/policy-rc.d > /dev/null
#!/bin/sh
echo "rc.d operations disabled for chroot"
exit 101
EOF

$cmd_sudo chmod 0755 $rootfs_dir/usr/sbin/policy-rc.d

print_msg "Importing Raspbian's GPG key...\n"

echo "deb $RASPBIAN_MIRROR/raspbian/ $RASPBIAN_VERSION main contrib non-free" | $cmd_sudo tee $rootfs_dir/etc/apt/sources.list > /dev/null

$cmd_sudo wget $RASPBIAN_MIRROR/raspbian.public.key -O $rootfs_dir/root/raspbian.key

run_chroot apt-key add /root/raspbian.key
run_chroot apt-get update

$cmd_sudo rm $rootfs_dir/root/raspbian.key

print_msg "Installing rpi-update into the rootfs and running it to fetch firmware and libraries...\n"

$cmd_sudo wget https://raw.github.com/Hexxeh/rpi-update/master/rpi-update -O $rootfs_dir/usr/bin/rpi-update
$cmd_sudo chmod +x $rootfs_dir/usr/bin/rpi-update
$cmd_sudo mkdir $rootfs_dir/lib/modules

run_chroot rpi-update

print_msg "Finished!"
