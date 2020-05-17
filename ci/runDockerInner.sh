#!/bin/sh

set -eu

if [ -x "$(command -v apt-get)" ]; then
  # Debian/Ubuntu
  apt-get update
  apt-get install -y curl
elif [ -x "$(command -v apk)" ]; then
  # Alpine
  apk update
  apk add curl
  apk add libc6-compat
fi

cd /app
"$1" ./ci/runTest.sh "$1"
