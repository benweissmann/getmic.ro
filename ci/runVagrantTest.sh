#!/bin/bash

set -euo pipefail

cd "$1"
vagrant up

# Delete any old copy of micro from a previous test run
vagrant ssh -c 'rm -f ./micro'

# Run the script
cat ../../index.sh | vagrant ssh -c sh

# Test that it installed
vagrant ssh -c './micro -version | grep "Version:"'

# Clean up
vagrant halt
