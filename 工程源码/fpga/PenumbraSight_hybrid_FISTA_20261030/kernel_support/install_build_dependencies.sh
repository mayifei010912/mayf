#!/bin/bash
set -eu
R=/home/ubuntu/penumbrasight_hybrid_20261031
exec > "$R/dependencies.log" 2>&1
trap 'echo $? > "$R/dependencies.status"' EXIT
printf '%s\n' "$1" | sudo -S -p '' -v
set --
sudo -n apt-get update
sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install -y flex bison libssl-dev libelf-dev bc kmod
echo DEPENDENCIES_READY
