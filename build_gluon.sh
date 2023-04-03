#!/bin/bash
OPENWRT_VERSION=22.03.2
DEFAULT_TARGETS="x86-generic ath79-generic ath79-nand ramips-mt76x8"

TARGETS="${TARGETS:-$DEFAULT_TARGETS}"
CPUS=`grep -c ^processor /proc/cpuinfo`

cd `dirname $0`/..

if [ "$1" != "" ]; then
    if [ "$1" == "testing" ]; then
        GLUON_RELEASE="${GLUON_RELEASE:-`date +%Y.%m.%d`}"
    elif [ "$1" == "early" ]; then
        YEAR=`date +%Y`
        LASTVER=`git -C site tag -l | grep $YEAR | cut -d. -f2`
        if [ "$LASTVER" == "" ]; then
            GLUON_RELEASE="${GLUON_RELEASE:-${YEAR}.1}-early"
        else
            GLUON_RELEASE="${GLUON_RELEASE:-${YEAR}.$(( $LASTVER + 1 ))}-early"
        fi
    elif [ "$1" == "stable" ]; then
        TAG=`git -C site describe --abbrev=0 --tags`
        GLUON_RELEASE="$TAG-stable"
        if [ "`git -C site log ${TAG}..HEAD`" != "" ]; then
            echo "Changes since last tag: ${TAG}"
            exit
        fi
    fi
    echo "Building Gluon Release ${GLUON_RELEASE} (${1}) for targets: ${TARGETS}..."
    if [ ! -f "$2" ]; then
        echo "Manifest will not be signed, because no secret was given."
    fi
else
    GLUON_RELEASE="${GLUON_RELEASE:-`date +%Y.%m.%d`}-dev"
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
        if [ "$?" != "0" ]; then
            pause
            make GLUON_TARGET=$T GLUON_RELEASE=$GLUON_RELEASE CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER=$OPENWRT_VERSION -j1 GLUON_AUTOUPDATER_ENABLED=1 V=sc
            exit
        fi
    else
        make GLUON_TARGET=$T GLUON_RELEASE=$GLUON_RELEASE CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER=$OPENWRT_VERSION -j$CPUS
        if [ "$?" != "0" ]; then
            pause
            make GLUON_TARGET=$T GLUON_RELEASE=$GLUON_RELEASE CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER=$OPENWRT_VERSION -j1 V=sc
            exit
        fi
    fi
done
if [ "$1" != "" ]; then
    echo "Creating Manifest..."
    make manifest GLUON_RELEASE=$GLUON_RELEASE GLUON_AUTOUPDATER_BRANCH=$1
    if [ -f "$2" ]; then
        echo "Signing Manifest..."
        contrib/sign.sh "$2" output/images/sysupgrade/${1}.manifest
    else
        echo "Manifest was not signed."
    fi
    echo "Creating Changelog..."
    (
    git -C site remote get-url origin
    git -C site diff -s && git -C site status -sb -uall
    if [ "$2" == "stable" ]; then
        LASTTAG=`git -C site tag -l | sort | grep -B1 ${TAG} | head -n1`
        git -C site log ${LASTTAG}..${TAG}
    else
        git -C site log `git -C site describe --abbrev=0 --tags`..HEAD
    fi
    ) > output/images/${GLUON_RELEASE}.changes
fi
echo "done."

