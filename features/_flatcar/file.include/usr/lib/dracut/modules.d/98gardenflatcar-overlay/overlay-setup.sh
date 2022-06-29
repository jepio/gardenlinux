#!/bin/bash

command -v getarg >/dev/null || . /lib/dracut-lib.sh

GENERATOR_DIR=$1

ovlconf=$(getarg gl.ovl=)
ovlconf=${ovlconf#gl.ovl=}
ovlconf="/usr/etc:etc,/usr/var:var"

if [ -z "$ovlconf" ]; then
    exit 0
fi

echo $ovlconf | awk -F, 'BEGIN {OFS="\n"}; {$1=$1; gsub(/:/, " "); print}' > /tmp/overlay.conf

# add a test for /tmp/overlay.conf
if [ ! -f /tmp/overlay.conf ]; then
    echo "there is no /tmp/overlay.conf - exiting"
    exit 1
fi


while read -r line; do
	what=$(echo "$line" | awk '{ print $1}')
	where=$(echo "$line" | awk '{ print $2}')
	dev=$(echo "$line" | awk '{ print $3}')
	unit=$(systemd-escape -p --suffix=mount "/sysroot/$where")
	upper="/sysroot/$where"
	work="/sysroot/$where.work"


	{
	echo "[Unit]"
	echo "Before=initrd-root-fs.target"
	echo "After=sysroot.mount sysroot-usr.mount"
	echo "DefaultDependencies=no"
	echo "Description=$unit"

	echo "[Mount]"
	echo "What=ovl_$where"
	echo "Where=/sysroot/$where"
	echo "Type=overlay"
	echo "Options=lowerdir=/sysroot$what,upperdir=$upper,workdir=$work"
	} > "$GENERATOR_DIR/$unit"

	mkdir -p "$GENERATOR_DIR"/initrd-root-fs.target.requires
	ln -s ../$unit $GENERATOR_DIR/initrd-root-fs.target.requires/$unit
done < /tmp/overlay.conf

exit 0
