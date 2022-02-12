#!/bin/sh

set -eu

shell="${@:-sh}"

echo '[INFO:] Using' $shell 'as the shell'
echo

if command -v sudo 1>/dev/null 2>&1 ; then
  withsudo() {
    sudo GETMICRO_PLATFORM="${GETMICRO_PLATFORM:-}" PATH="${PATH:-}" GETMICRO_REGISTER="${GETMICRO_REGISTER:-}" "$@"
  }
else
  withsudo() {
    "$@"
  }
fi

echo
echo Testing micro version

cat index.sh | withsudo $shell
(./micro -version | grep 'Version:') || \
  (echo 'Fail: micro installation test' && exit 1)

if [ "x$GETMICRO_REGISTER" = "xy" ] && command -v update-alternatives 2>/dev/null ; then
  if ! realpath /usr/bin/editor | grep -q micro ; then
    echo 'Fail: requested GETMICRO_REGISTER=y but /usr/bin/editor does not point to micro'
    exit 1
  fi
fi

unset GETMICRO_PLATFORM || true
export PATH="./ci/fixtures:$PATH"

# Clean up from former tests
withsudo rm -rf ./micro* 2>/dev/null || true

echo
echo Testing unrecognized platform
unset GETMICRO_PLATFORM
(cat index.sh | withsudo $shell 2>&1 | grep --color=always -ne 'COULD NOT DETECT PLATFORM') || \
  (echo 'Test Failed: expected unrecognized platform error' && exit 1)
echo Test was SUCCESSful!
echo

echo
echo Testing linux32 platform:
export GETMICRO_PLATFORM=linux32
(cat index.sh | withsudo $shell 2>&1 | grep --color=always -ne 'Detected platform: linux32') || \
  (echo 'Test Failed: expected linux32 detection due to override' && exit 1)
echo Test was SUCCESSful!
echo

echo
echo Testing linux64 platform:
export GETMICRO_PLATFORM=linux64
(cat index.sh | withsudo $shell 2>&1 | grep --color=always -ne 'Detected platform: linux64') || \
  (echo 'Test Failed: expected linux64 detection due to override' && exit 1)
echo Test was SUCCESSful!
echo

echo
echo Testing win32 platform:
export GETMICRO_PLATFORM=win32
(cat index.sh | withsudo $shell 2>&1 | grep --color=always -ne 'Detected platform: win32') || \
  (echo 'Test Failed: expected win32 detection due to override' && exit 1)
echo Test was SUCCESSful!
echo

echo
echo Testing win64 platform:
export GETMICRO_PLATFORM=win64
(cat index.sh | withsudo $shell 2>&1 | grep --color=always -ne 'Detected platform: win64') || \
  (echo 'Test Failed: expected win64 detection due to override' && exit 1)
echo Test was SUCCESSful!
echo

# Clean up our tests just now
withsudo rm -rf ./micro* 2>/dev/null || true
