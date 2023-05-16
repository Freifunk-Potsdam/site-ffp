#!/usr/bin/env bash

test "site" = "$(basename "$(dirname "$(realpath "$0")")")" || exit
cd "$(dirname "$0")"/.. || exit
. ./site/build_vars.sh

GLUON_RELEASE="${GLUON_RELEASE:-$(date +%Y.%m.%d)}"
if [ "$(git -C site branch --show-current)" != "main" ]; then
    echo "Not on main branch."
    exit
elif [ "$(git -C site status -s)" != "" ]; then
    echo "Changes in main branch."
    exit
fi

echo "Building Gluon Release ${GLUON_RELEASE} for targets: ${TARGETS}..."
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
        echo "Error building $T."
        exit
    fi
done
for BRANCH in stable early testing ; do
    make manifest GLUON_RELEASE="$GLUON_RELEASE" GLUON_AUTOUPDATER_BRANCH="$BRANCH"
    if [ -f "$1" ]; then
        echo "Signing ${BRANCH}.manifest..."
        contrib/sign.sh "$1" output/images/sysupgrade/"${BRANCH}".manifest
    else
        echo "${BRANCH}.manifest was not signed."
    fi
done

echo "Creating Changelog..."
git -C site tag -d "${GLUON_RELEASE}" 2> /dev/null
(
    git -C site remote get-url origin
    git -C site diff -s && git -C site status -sb -uall
    git -C site log "$(git -C site describe --abbrev=0 --tags)"..HEAD
) > output/images/"${GLUON_RELEASE}".changes
git -C site tag "${GLUON_RELEASE}"
echo "done."
