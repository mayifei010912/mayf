#!/bin/bash
set -euo pipefail
R=/home/ubuntu/penumbrasight_hybrid_20261031
exec > "$R/build.log" 2>&1
trap 'echo $? > "$R/build.status"' EXIT
cd "$R"
test "$(sha256sum kernel.tar.gz | cut -d' ' -f1)" = 5e84f1b07def9782b6641b2db08ac9d40f58a8cc4f75677f6769e7ce7d4bf420
test -f dependencies.status && test "$(cat dependencies.status)" = 0
if test ! -d atk-zup-linux-xlnx; then tar -xzf kernel.tar.gz; fi
if test ! -d gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu; then tar -xJf toolchain.tar.xz; fi
export ARCH=arm64
export CROSS_COMPILE="$R/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"
"${CROSS_COMPILE}gcc" --version | head -1
mkdir -p "$R/build-atk" "$R/driver"
cp board.config "$R/build-atk/.config"
cp penumbra_gram.c Makefile "$R/driver/"
make -C atk-zup-linux-xlnx O="$R/build-atk" olddefconfig
python3 - <<'PY'
import re,pathlib,json
r=pathlib.Path('/home/ubuntu/penumbrasight_hybrid_20261031')
def opts(p):return dict(re.findall(r'^(CONFIG_\w+)=(.*)$',p.read_text(),re.M))
a,b=opts(r/'board.config'),opts(r/'build-atk/.config')
changes=[{'option':k,'board':v,'build':b.get(k)} for k,v in a.items() if b.get(k)!=v]
(r/'config_changes.json').write_text(json.dumps(changes,indent=2))
print('CONFIG_DIFFERENCES',changes)
# Two absent vendor image-sensor drivers are not used by this buffer-only module.
# We build only the external module, never this incomplete kernel or its image.
# All DMA, architecture, device, memory and module configuration must still match.
allowed={'CONFIG_CC_VERSION_TEXT','CONFIG_GCC_VERSION','CONFIG_CLANG_VERSION','CONFIG_CC_HAS_ASM_INLINE','CONFIG_VIDEO_IMX415','CONFIG_VIDEO_OS05A10'}
bad=[d for d in changes if d['option'] not in allowed]
if bad:raise SystemExit('Kernel config changed beyond compiler metadata; inspect before loading')
PY
# Linux 5.4 DTC host tools predate GCC 10's -fno-common default.
# This applies only to x86 host utilities, not the AArch64 module compiler.
make -C atk-zup-linux-xlnx O="$R/build-atk" HOSTCFLAGS="-O2 -fcommon" -j4 modules_prepare
test "$(cat build-atk/include/config/kernel.release)" = 5.4.0
make -C build-atk M="$R/driver" HOSTCFLAGS="-O2 -fcommon" -j4 modules
modinfo "$R/driver/penumbra_gram.ko"
"${CROSS_COMPILE}readelf" -h "$R/driver/penumbra_gram.ko"
"${CROSS_COMPILE}nm" -u "$R/driver/penumbra_gram.ko" > "$R/undefined_symbols.txt"
sha256sum "$R/driver/penumbra_gram.ko"
echo DRIVER_BUILD_COMPLETE_NOT_YET_LOADED
