#!/usr/bin/env bash

set -Eeuo pipefail
set -x

size=1073741824

while read -r  source target fs options args; do
  if [ "${target}" != "/usr" ]; then
    echo "${source} ${target} ${fs} ${options} ${args}"
    continue
  else
    echo "LABEL=USR-A ${target} ${fs} ${options} ${args:+${args},}size=$size"
    echo "LABEL=USR-B none none ${options},noauto ${args:+${args},}size=$size"
  fi
done
