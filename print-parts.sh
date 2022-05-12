#!/bin/bash

cat features/base/fstab | features/cloud/fstab.mod | features/_flatcar/fstab.mod 2>/dev/null | sed 's/#.*//;/^[[:blank:]]*$/d' \
| while IFS= read -r line; do
	# get fstab entry target path depth
	depth=$(echo "$line" | awk '{ print $2 }' | sed 's#^/\+##;s#/\+$##' | awk -F '/' '{ print NF }')
	echo "$depth" "$line"
  done \
| sort -k 1nr
