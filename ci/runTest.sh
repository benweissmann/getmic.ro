#!/usr/bin/env bash

set -euo pipefail

cat index.sh | bash
./micro -version | grep 'Version:'

unset GETMICRO_PLATFORM
export OSTYPE='xxx'

set +o pipefail
cat index.sh | bash | grep 'COULD NOT DETECT PLATFORM'
set -o pipefail

export GETMICRO_PLATFORM=linux32
cat index.sh | bash | grep 'Detected platform: linux32'

export OSTYPE='darwin'
export GETMICRO_PLATFORM=linux64
cat index.sh | bash | grep 'Detected platform: linux64'
