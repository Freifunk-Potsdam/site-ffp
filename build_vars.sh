#!/usr/bin/env bash

# check and abort on unbound vars
set -o nounset
# show errors in pipes
set -o pipefail

OPENWRT_VERSION=23.05.2
DEFAULT_TARGETS="
    armsr-armv7
    armsr-armv8
    ath79-generic
    ath79-mikrotik
    ath79-nand
    bcm27xx-bcm2709
    ipq40xx-generic
    ipq40xx-mikrotik
    ipq806x-generic
    lantiq-xrx200
    lantiq-xway
    mediatek-filogic
    mediatek-mt7622
    mpc85xx-p1010
    mpc85xx-p1020
    ramips-mt7620
    ramips-mt7621
    ramips-mt76x8
    realtek-rtl838x
    rockchip-armv8
    sunxi-cortexa7
    x86-64
    x86-generic
    x86-geode
    x86-legacy
"

TARGETS="${TARGETS:-$DEFAULT_TARGETS}"
CPUS=$(nproc)
