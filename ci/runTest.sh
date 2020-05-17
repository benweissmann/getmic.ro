#!/bin/sh

set -eu

cat index.sh | "$1"
./micro -version | grep 'Version:'

unset GETMICRO_PLATFORM
export OSTYPE='xxx'

cat index.sh | "$1" | grep 'COULD NOT DETECT PLATFORM'

export GETMICRO_PLATFORM=linux32
cat index.sh | "$1" | grep 'Detected platform: linux32'

export OSTYPE='darwin'
export GETMICRO_PLATFORM=linux64
cat index.sh | "$1" | grep 'Detected platform: linux64'
