#!/usr/bin/env bash

set -euo pipefail

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
./ci/runTest.sh
