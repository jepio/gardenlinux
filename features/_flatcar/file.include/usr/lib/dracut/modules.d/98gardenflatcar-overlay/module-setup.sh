#!/bin/bash

check() {
    [[ $mount_needs ]] && return 1
    return 0
}

depends() {
    echo "fs-lib dracut-systemd"
}

install() {
    #inst_multiple grep sfdisk growpart udevadm awk mawk sed rm readlink
    #inst_multiple curl grep sfdisk awk mawk sha256sum
    inst_multiple awk

    inst_script "$moddir/overlay-setup.sh" $systemdutildir/system-generators/overlay-setup
}
