#!/bin/bash

set -euo pipefail

# Set up qemu for arm images
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# Run /app/ci/runDockerInner.sh inside Docker
docker run --rm -v "$PWD:/app" $1 /app/ci/runDockerInner.sh "$2"
