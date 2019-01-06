#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo 'Lint only runs on linux in CI'
  exit 0
fi

shellcheck ./index.sh
