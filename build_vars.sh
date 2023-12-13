#!/usr/bin/env bash

# check and abort on unbound vars
set -o nounset
# show errors in pipes
set -o pipefail

OPENWRT_VERSION=22.03
DEFAULT_TARGETS="x86-generic ath79-generic ath79-nand ramips-mt76x8 ramips-mt7621"

TARGETS="${TARGETS:-$DEFAULT_TARGETS}"
CPUS=$(nproc)
