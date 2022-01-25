#!/bin/sh

set -eu

shell=${1:-sh}

cat index.sh | "$shell"
(./micro -version | grep 'Version:') || \
  (echo 'Fail: micro installation test' && exit 1)

unset GETMICRO_PLATFORM
export PATH="./ci/fixtures:$PATH"

# Clean up from former tests
rm -rf ./micro* 2>/dev/null || true

(cat index.sh | "$shell" 2>&1 | grep 'COULD NOT DETECT PLATFORM') || \
  (echo 'Fail: unrecognized platform test' && exit 1)

export GETMICRO_PLATFORM=linux32
(cat index.sh | "$shell" | grep 'Detected platform: linux32') || \
  (echo 'Fail: linux32 override test' && exit 1)

export GETMICRO_PLATFORM=linux64
(cat index.sh | "$shell" | grep 'Detected platform: linux64') || \
  (echo 'Fail: linux64 override test' && exit 1)

export GETMICRO_PLATFORM=win32
(cat index.sh | "$shell" | grep 'Detected platform: win32') || \
  (echo 'Fail: win32 override test' && exit 1)

export GETMICRO_PLATFORM=win64
(cat index.sh | "$shell" | grep 'Detected platform: win64') || \
  (echo 'Fail: win64 override test' && exit 1)
