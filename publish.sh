#!/bin/bash

SHA=$(shasum -a 256 index.sh | cut -d ' ' -f1)
gsed -i 's/The sha256 checksum is `.*`/The sha256 checksum is `'$SHA'`/' README.md

aws s3 cp ./index.sh s3://getmic.ro/index.sh \
  --content-type 'text/plain' \
  --cache-control 'max-age=60' \
  --acl public-read

aws cloudfront create-invalidation \
  --distribution-id E2G1BMMQRRIIVO \
  --paths '/*'

git add ./README.md
git commit -m "[chore] Update README with new checksum"
git push