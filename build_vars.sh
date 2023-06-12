#!/usr/bin/env bash

# check and abort on unbound vars
set -o nounset
# show errors in pipes
set -o pipefail

OPENWRT_VERSION=22.03.2
DEFAULT_TARGETS="x86-generic ath79-generic ath79-nand ramips-mt76x8 ramips-mt7620 ramips-mt7621"
declare -A BUILD_BROKEN_DEVICES
BUILD_BROKEN_DEVICES['ramips-mt7621']="zyxel-nwa55axe"

TARGETS="${TARGETS:-$DEFAULT_TARGETS}"
CPUS=$(nproc)
