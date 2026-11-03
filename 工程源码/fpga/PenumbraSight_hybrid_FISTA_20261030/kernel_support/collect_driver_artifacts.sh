#!/bin/bash
set -eu
R=/home/ubuntu/penumbrasight_hybrid_20261031
test "$(cat "$R/build.status")" = 0
"$R/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-objcopy" --strip-debug "$R/driver/penumbra_gram.ko" "$R/penumbra_gram.ko"
sha256sum "$R/penumbra_gram.ko" > "$R/driver_sha256.txt"
