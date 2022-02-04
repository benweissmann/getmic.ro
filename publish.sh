#!/bin/bash

set -euo pipefail

cd "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cmdexists() {
  command -v "$1" >/dev/null 2>&1
}

if ! cmdexists gsed ; then
  if cmdexists sed && sed --version | grep -q '(GNU sed)' ; then
    # gsed doesnt exist on many distros; instead, sed 
    gsed() {
      sed "$@"
    }
  else
    echo 'FATAL ERROR: GNU sed is needed by this script but is not installed. Please install gsed' 1>&2
    exit 1
  fi
fi

if cmdexists apt-get && cmdexists sudo ; then
  # according to order of operations, this is ! ( cmdexists aws && cmdexists git )
  if ! cmdexists aws && cmdexists git ; then
    echo 'Need to install aws and git in order to proceed' 1>&2
    sudo apt-get install -y awscli git
  fi
fi

SHA=$(shasum -a 256 index.sh | cut -d ' ' -f1)
OLDSHA=$(grep -oe '<!--shasum=.*-->' README.md | grep -Eoe '[a-f0-9]{64}')
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
