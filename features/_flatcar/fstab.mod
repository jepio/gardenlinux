#!/usr/bin/env bash

set -Eeuo pipefail
set -x

# 1023 * 1024 * 1024. makepart adds 1MB somewhere
size=1072693248
flatcar_rootfs=5DFBF5F4-2848-4BAC-AA5E-0D9A20B745A6

while read -r  source target fs options args; do
  if [ "${source}" = LABEL=EFI ]; then
    source=LABEL=EFI-SYSTEM
    args="${args:+${args},}size=$(( 256 * 1024 * 1024 ))"
  fi
  if [ "${target}" != "/usr" ]; then
    echo "${source} ${target} ${fs} ${options} ${args}"
    continue
  else
    echo "LABEL=USR-A ${target} ext2 ${options} ${args:+${args},}size=$size,type=$flatcar_rootfs,overlay"
    echo "LABEL=USR-B none none ${options},noauto ${args:+${args},}size=$size,type=$flatcar_rootfs"
  fi
done

#echo "LABEL=5ROOT-C none none noauto size=0"
#echo "LABEL=2BIOS-BOOT none none noauto size=$(( 2 * 1024 * 1024 ))"
echo "LABEL=OEM /oem ext4 noauto size=$(( 128 * 1024 * 1024 ))"
#echo "LABEL=OEM-CONFIG none none noauto size=$(( 64 * 1024 * 1024 ))"
#echo "LABEL=reserved none none noauto size=0"
