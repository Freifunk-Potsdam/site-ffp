#!/bin/bash
OPENWRT_VERSION=22.03.2
DEFAULT_TARGETS="x86-generic ath79-generic ath79-nand ramips-mt76x8"

GLUON_RELEASE="${GLUON_RELEASE:-`date +%Y.%m.%d`}"
TARGETS="${TARGETS:-$DEFAULT_TARGETS}"
CPUS=`grep -c ^processor /proc/cpuinfo`

cd `dirname $0`/..

if [ "$1" != "" ]; then
    echo "Building Gluon Release ${GLUON_RELEASE} (${1}) for targets: ${TARGETS}..."
    if [ ! -f "$2" ]; then
        echo "Manifest will not be signed, because no secret was given."
    fi
else
    echo "Building Gluon Dev-Release ${GLUON_RELEASE} for targets: ${TARGETS}..."
fi

echo "Cleaning Output..."
rm -rf output
echo "Updating Modules..."
make update
for T in $TARGETS; do
    echo "Building Target $T..."
    if [ "$1" != "" ]; then
        make GLUON_TARGET=$T GLUON_RELEASE=$GLUON_RELEASE CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER=$OPENWRT_VERSION -j$CPUS GLUON_AUTOUPDATER_ENABLED=1
    else
        make GLUON_TARGET=$T GLUON_RELEASE=$GLUON_RELEASE CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER=$OPENWRT_VERSION -j$CPUS
    fi
done
