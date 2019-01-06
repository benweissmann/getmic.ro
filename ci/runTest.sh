#!/bin/bash

set -euo pipefail

bash index.sh
./micro -h | grep 'Usage: micro'
