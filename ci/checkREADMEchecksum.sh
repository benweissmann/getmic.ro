#!/usr/bin/env bash

# ensures the checksum is in the readme file

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

checksum=$(shasum -a 256 "$SCRIPT_DIR/../index.sh" | cut -d' ' -f1)

echo
echo '[INFO:] checksum of index.sh is' $checksum
echo

echo "$1:"
if grep --color=always -ne $checksum "$1" ; then
  echo
  echo '[SUCCESS:] the file' "$1" 'contains the checksum ('$checksum')'
  echo
else
  echo '  (no matches found)'
  echo
  echo '[FAILURE:] the file' "$1" 'does not contains the checksum ('$checksum')'
  echo
  echo '[NOTICE:] to fix this error, update the checksums in the file' "$1"
  echo
  exit 1
fi

