#!/bin/sh

set -eu

shell=${1:-bash}

cat index.sh | "$shell"
./micro -version | grep 'Version:'

unset GETMICRO_PLATFORM
export OSTYPE='xxx'

cat index.sh | "$shell" | grep 'COULD NOT DETECT PLATFORM'

export GETMICRO_PLATFORM=linux32
cat index.sh | "$shell" | grep 'Detected platform: linux32'

export OSTYPE='darwin'
export GETMICRO_PLATFORM=linux64
cat index.sh | "$shell" | grep 'Detected platform: linux64'
