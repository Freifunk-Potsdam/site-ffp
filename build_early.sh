#!/usr/bin/env bash

BRANCH=early

cd `dirname $0`/..
. site/build_vars.sh

if [ "`git branch --show-current`" != "main" ]; then
    echo "Not on main branch."
    exit
elif [ "`git status -s`" != "" ]; then
    echo "Changes in main branch."
    exit
fi
YEAR=`date +%Y`
LASTVER=`git -C site tag -l | grep $YEAR | cut -d. -f2 | sort -g | tail -n1`
if [ "$LASTVER" == "" ]; then
    GLUON_RELEASE="${GLUON_RELEASE:-${YEAR}.1}-${BRANCH}"
else
    GLUON_RELEASE="${GLUON_RELEASE:-${YEAR}.$(( $LASTVER + 1 ))}-${BRANCH}"
fi
echo "Building Gluon Release ${GLUON_RELEASE} (${BRANCH}) for targets: ${TARGETS}..."
if [ ! -f "$1" ]; then
    echo "Manifest will not be signed, because no secret was given."
fi

echo "Cleaning Output..."
rm -rf output
echo "Updating Modules..."
make update
for T in $TARGETS; do
    echo "Building Target $T..."
    make GLUON_TARGET=$T GLUON_RELEASE=$GLUON_RELEASE CONFIG_VERSIONOPT=y CONFIG_VERSION_NUMBER=$OPENWRT_VERSION -j$CPUS GLUON_AUTOUPDATER_ENABLED=1
    if [ "$?" != "0" ]; then
        echo "Error building $T."
        exit
    fi
done
echo "Creating Manifest..."
make manifest GLUON_RELEASE=$GLUON_RELEASE GLUON_AUTOUPDATER_BRANCH=$BRANCH
if [ -f "$1" ]; then
    echo "Signing Manifest..."
    contrib/sign.sh "$1" output/images/sysupgrade/${BRANCH}.manifest
else
    echo "Manifest was not signed."
fi
echo "Creating Changelog..."
(
git -C site remote get-url origin
git -C site diff -s && git -C site status -sb -uall
git -C site log `git -C site describe --abbrev=0 --tags`..HEAD
) > output/images/${GLUON_RELEASE}.changes
echo "done."

