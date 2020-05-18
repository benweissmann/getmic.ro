#!/bin/bash

set -euo pipefail

for vagrantfile in testboxes/*/Vagrantfile; do
  ./ci/runVagrantTest.sh "$(dirname $vagrantfile)"
done
