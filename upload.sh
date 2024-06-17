#!/bin/bash
cd `dirname $0`/..
RELEASE=`head -n5 output/images/sysupgrade/*.manifest | tail -n1 | cut -d' ' -f2`

if [ "$RELEASE" != "" ]; then
    rsync -av --delete output/packages/gluon-ffp-${RELEASE}/ root@kira.freifunk-potsdam.de:/docker/www/firmware/feed/gluon/core/gluon-ffp-${RELEASE}/
    rsync -av --delete output/images/ root@kira.freifunk-potsdam.de:/docker/www/firmware/gluon/$RELEASE/
fi
