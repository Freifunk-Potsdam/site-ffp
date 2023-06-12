#!/usr/bin/env bash

BRANCH=testing

test "site" = "$(basename "$(dirname "$(realpath "$0")")")" || exit
cd "$(dirname "$0")"/.. || exit
. ./site/build_vars.sh

GLUON_RELEASE="${GLUON_RELEASE:-$(date +%Y.%m.%d)}"
echo "Building Gluon Release ${GLUON_RELEASE} (${BRANCH}) for targets: ${TARGETS}..."
if [ ! -f "$1" ]; then
    echo "Manifest will not be signed, because no secret was given."
fi

echo "Cleaning Output..."
test -d ./output && rm -rf ./output
echo "Updating Modules..."
make update
for T in $TARGETS; do
    echo "Building Target $T..."
    make GLUON_TARGET="$T" GLUON_RELEASE="$GLUON_RELEASE" CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER="$OPENWRT_VERSION" -j"$CPUS" GLUON_AUTOUPDATER_ENABLED=1
    if [ "$?" != "0" ]; then
        echo "Error building $T, press Enter to rebuild with V=sc..."
        read
        make GLUON_TARGET="$T" GLUON_RELEASE="$GLUON_RELEASE" CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER="$OPENWRT_VERSION" -j1 GLUON_AUTOUPDATER_ENABLED=1 V=sc
        exit
    fi
    if [ "${BUILD_BROKEN_DEVICES[$T]+x}" != "" ]; then
        for D in ${BUILD_BROKEN_DEVICES[$T]}; do
            echo "Building Target $T, broken device $D..."
            make GLUON_TARGET="$T" GLUON_DEVICE="$D" BROKEN=1 GLUON_RELEASE="$GLUON_RELEASE" CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER="$OPENWRT_VERSION" -j"$CPUS" GLUON_AUTOUPDATER_ENABLED=1
            if [ "$?" != "0" ]; then
                echo "Error building $T $D, press Enter to rebuild with V=sc..."
                read
                make GLUON_TARGET="$T" GLUON_DEVICE="$D" BROKEN=1 GLUON_RELEASE="$GLUON_RELEASE" CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER="$OPENWRT_VERSION" -j1 GLUON_AUTOUPDATER_ENABLED=1 V=sc
                exit
            fi
        done
    fi
done
echo "Creating Manifest..."
make manifest GLUON_RELEASE="$GLUON_RELEASE" GLUON_AUTOUPDATER_BRANCH="$BRANCH"
if [ -f "$1" ]; then
    echo "Signing Manifest..."
    contrib/sign.sh "$1" output/images/sysupgrade/"${BRANCH}".manifest
else
    echo "Manifest was not signed."
fi
echo "Creating Changelog..."
(
    git -C site remote get-url origin
    git -C site diff -s && git -C site status -sb -uall
    git -C site log "$(git -C site describe --abbrev=0 --tags)"..HEAD
) > output/images/"${GLUON_RELEASE}".changes
echo "done."
