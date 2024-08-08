#! /bin/bash

# The purpose of this script is to remove any grub configurations prior to install so that the bootloader is always up to date on what is on the installation media.
dd if=/dev/zero of=/dev/sda bs=512 count=200
