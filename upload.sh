#!/bin/bash
cd `dirname $0`/..
RELEASE=`head -n5 output/images/sysupgrade/*.manifest | tail -n1 | cut -d' ' -f2`

if [ "$RELEASE" != "" ]; then
    scp -r output/packages/* root@firmware.freifunk-potsdam.de:/docker/www/firmware/feed/gluon/core/
    scp -r output/images root@firmware.freifunk-potsdam.de:/docker/www/firmware/gluon/$RELEASE
fi
