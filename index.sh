#!/usr/bin/env bash

# This script installs micro.
#
# Quick install: `curl https://getmic.ro | bash`
#
# This script will install micro to the directory you're in. To install
# somewhere else (e.g. /usr/local/bin), cd there and make sure you can write to
# that directory, e.g. `cd /usr/local/bin; curl https://getmic.ro | sudo bash`
#
# Found a bug? Report it here: https://github.com/benweissmann/getmic.ro
#
# Acknowledgments:
#   - Micro, of course: https://micro-editor.github.io/
#   - Loosely based on the Chef curl|bash: https://docs.chef.io/install_omnibus.html
#   - ASCII art courtesy of figlet: http://www.figlet.org/


set -e
set -u
set -o pipefail

function githubLatestTag {
    finalUrl=$(curl "https://github.com/$1/releases/latest" -s -L -I -o /dev/null -w '%{url_effective}')
    echo "${finalUrl##*v}"
}


platform=''
machine=$(uname -m)

if test "${GETMICRO_PLATFORM:-x}" != "x"; then
  platform="$GETMICRO_PLATFORM"
elif [[ "$OSTYPE" == "linux"* ]]; then
  if [[ "$machine" == "arm"* || "$machine" == "aarch"* ]]; then
    platform='linux-arm'
  elif [[ "$machine" == *"86" ]]; then
    platform='linux32'
  elif [[ "$machine" == *"64" ]]; then
    platform='linux64'
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  platform='osx'
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  if [[ "$machine" == *"64" ]]; then
    platform='freebsd64'
  elif [[ "$machine" == *"86" ]]; then
    platform='freebsd32'
  fi
elif [[ "$OSTYPE" == "openbsd"* ]]; then
  if [[ "$machine" == *"64" ]]; then
    platform='openbsd64'
  elif [[ "$machine" == *"86" ]]; then
    platform='openbsd32'
  fi
elif [[ "$OSTYPE" == "netbsd"* ]]; then
  if [[ "$machine" == *"64" ]]; then
    platform='netbsd64'
  elif [[ "$machine" == *"86" ]]; then
    platform='netbsd32'
  fi
fi

if test "x$platform" = "x"; then
  cat <<EOM
/=====================================\\
|      COULD NOT DETECT PLATFORM      |
\\=====================================/

Uh oh! We couldn't automatically detect your operating system. You can file a
bug here: https://github.com/benweissmann/getmic.ro

To continue with installation, please choose from one of the following values:

- freebsd32
- freebsd64
- linux-arm
- linux32
- linux64
- netbsd32
- netbsd64
- openbsd32
- openbsd64
- osx
- win32
- win64

Export your selection as the GETMICRO_PLATFORM environment variable, and then
re-run this script.

For example:

  $ export GETMICRO_PLATFORM=linux64
  $ curl https://getmic.ro | bash

EOM
  exit 1
else
  echo "Detected platform: $platform"
fi

TAG=$(githubLatestTag zyedidia/micro)

echo "Downloading https://github.com/zyedidia/micro/releases/download/v$TAG/micro-$TAG-$platform.tar.gz"
curl -L "https://github.com/zyedidia/micro/releases/download/v$TAG/micro-$TAG-$platform.tar.gz" > micro.tar.gz

tar -xvzf micro.tar.gz "micro-$TAG/micro"
mv "micro-$TAG/micro" ./micro

rm micro.tar.gz
rm -rf "micro-$TAG"

cat <<-'EOM'


 __  __ _                  ___           _        _ _          _ _
|  \/  (_) ___ _ __ ___   |_ _|_ __  ___| |_ __  | | | ___  __| | |
| |\/| | |/ __| '__/ _ \   | || '_ \/ __| __/ _\ | | |/ _ \/ _  | |
| |  | | | (__| | | (_) |  | || | | \__ \ || (_| | | |  __/ (_| |_|
|_|  |_|_|\___|_|  \___/  |___|_| |_|___/\__\__,_|_|_|\___|\__,_(_)

Micro has been downloaded to the current directory. You can run it with:

./micro


EOM
