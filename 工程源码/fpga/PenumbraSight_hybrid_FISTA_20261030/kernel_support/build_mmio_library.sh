#!/bin/bash
set -eu
R=/home/ubuntu/penumbrasight_hybrid_20261031
CC="$R/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"
"${CC}gcc" -shared -fPIC -O2 -Wall -Wextra -Werror "$R/hybrid_mmio.c" -o "$R/libhybrid_mmio.so"
"${CC}objdump" -d "$R/libhybrid_mmio.so" > "$R/mmio_disassembly.txt"
