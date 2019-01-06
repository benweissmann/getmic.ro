#!/bin/bash

set -euo pipefail

bash index.sh
./micro -version | grep 'Version:'
