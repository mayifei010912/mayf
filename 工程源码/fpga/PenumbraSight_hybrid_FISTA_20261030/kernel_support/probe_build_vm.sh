#!/bin/bash
set -eu
mkdir -p /home/ubuntu/penumbrasight_hybrid_20261031
exec > /home/ubuntu/penumbrasight_hybrid_20261031/environment.txt 2>&1
id
uname -a
df -h /home/ubuntu
for c in gcc make flex bison aarch64-linux-gnu-gcc aarch64-none-linux-gnu-gcc; do command -v "$c" || true; done
gcc --version | head -1
dpkg-query -W gcc-aarch64-linux-gnu libssl-dev libelf-dev flex bison 2>/dev/null || true
sudo -n true && echo SUDO_NONINTERACTIVE_OK || true
find /opt /home/ubuntu -maxdepth 3 -type f -name '*aarch64*gcc' 2>/dev/null | head -10
