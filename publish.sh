#!/bin/bash

set -euo pipefail

SHA=$(shasum -a 256 index.sh | cut -d ' ' -f1)
OLDSHA=$(rg -o 'The sha256 checksum is `([a-f0-9]+)`' -r '$1' < README.md)
gsed -i "s/$OLDSHA/$SHA/" README.md
gsed -i "s/$OLDSHA/$SHA/" README.fr.md

aws s3 cp ./index.sh s3://getmic.ro/index.sh \
  --content-type 'text/plain' \
  --cache-control 'max-age=60' \
  --acl public-read

aws cloudfront create-invalidation \
  --distribution-id E2G1BMMQRRIIVO \
  --paths '/*'

git add ./README.md ./README.fr.md
git commit -m "[chore] Update README files with new checksum"
git push
