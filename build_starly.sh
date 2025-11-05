#!/usr/bin/env bash

test "site" = "$(basename "$(dirname "$(realpath "$0")")")" || exit
cd "$(dirname "$0")"/.. || exit
. ./site/build_vars.sh

GLUON_RELEASE="${GLUON_RELEASE:-$(date +%Y.%m.%d)}"
SECRET="${1:-}"

echo
if [ "$(git -C site branch --show-current)" != "main" ]; then
    echo "!!! Site config not on main branch. !!!"
fi
if [ "$(git -C site status -s)" != "" ]; then
    echo "!!! Changes in site config. !!!"
fi

if [ ! -f "$SECRET" ]; then
    echo "!!! Manifest will not be signed, because no secret was given. !!!"
fi
echo "Gluon version tag: $(git describe --abbrev=0 --tags)"
echo
echo "Building Gluon Release ${GLUON_RELEASE} for targets: ${TARGETS}..."
echo
echo -n "Proceed ? [y/N] "
read yes
if [ "$yes" != "y" -a "$yes" != "Y" ]; then
    exit
fi

echo "Cleaning Output..."
test -d ./output && rm -rf ./output
mkdir -p output/images/

echo "Creating Changelog for ${GLUON_RELEASE}..."
git -C site tag -d "${GLUON_RELEASE}" 2> /dev/null
(
    git -C site remote get-url origin
    git -C site diff -s && git -C site status -sb -uall
    git -C site log "$(git -C site describe --abbrev=0 --tags)"..HEAD
) > output/images/"${GLUON_RELEASE}".changes
git -C site tag "${GLUON_RELEASE}"

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
    today=$( date +%Y-%m-%d )
    in2w=$( date --date "2 weeks" +%Y-%m-%d )
    in4w=$( date --date "4 weeks" +%Y-%m-%d )
    if [ "$BRANCH" == "early" ]; then
        make manifest GLUON_RELEASE="$GLUON_RELEASE" GLUON_AUTOUPDATER_BRANCH="$BRANCH" GLUON_PRIORITY="3"
        sed -i "s/DATE=$today /DATE=$in2w /" output/images/sysupgrade/"${BRANCH}".manifest
    elif [ "$BRANCH" == "stable" ]; then
        make manifest GLUON_RELEASE="$GLUON_RELEASE" GLUON_AUTOUPDATER_BRANCH="$BRANCH" GLUON_PRIORITY="7"
        sed -i "s/DATE=$today /DATE=$in4w /" output/images/sysupgrade/"${BRANCH}".manifest
    else
        make manifest GLUON_RELEASE="$GLUON_RELEASE" GLUON_AUTOUPDATER_BRANCH="$BRANCH" GLUON_PRIORITY="0"
    fi
    if [ -f "$SECRET" ]; then
        echo "Signing ${BRANCH}.manifest..."
        contrib/sign.sh "$SECRET" output/images/sysupgrade/"${BRANCH}".manifest
    else
        echo "${BRANCH}.manifest was not signed."
    fi
done

echo "done."
