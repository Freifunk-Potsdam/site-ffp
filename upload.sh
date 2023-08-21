#!/bin/bash
cd `dirname $0`/..
RELEASE=`head -n5 output/images/sysupgrade/*.manifest | tail -n1 | cut -d' ' -f2`

if [ "$RELEASE" != "" ]; then
    rsync -av --delete output/packages/gluon-ffp-${RELEASE}/ root@daria.freifunk-potsdam.de:/data/www/firmware/feed/gluon/core/gluon-ffp-${RELEASE}/
    rsync -av --delete output/images/ root@daria.freifunk-potsdam.de:/data/www/firmware/gluon/$RELEASE/
fi
