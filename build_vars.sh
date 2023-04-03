#!/usr/bin/env bash

OPENWRT_VERSION=22.03.2
DEFAULT_TARGETS="x86-generic ath79-generic ath79-nand ramips-mt76x8"

TARGETS="${TARGETS:-$DEFAULT_TARGETS}"
CPUS=`grep -c ^processor /proc/cpuinfo`
