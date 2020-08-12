#!/bin/sh

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

set -e -u

githubLatestTag() {
  finalUrl=$(curl "https://github.com/$1/releases/latest" -s -L -I -o /dev/null -w '%{url_effective}')
  printf "%s\n" "${finalUrl##*v}"
}

platform=''
machine=$(uname -m)

if [ "${GETMICRO_PLATFORM:-x}" != "x" ]; then
  platform="$GETMICRO_PLATFORM"
else
  case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    "linux")
      case "$machine" in
        "arm64"* | "aarch64"* ) platform='linux-arm64' ;;
        "arm"* | "aarch"*) platform='linux-arm' ;;
        *"86") platform='linux32' ;;
        *"64") platform='linux64' ;;
      esac
      ;;
    "darwin") platform='osx' ;;
    *"freebsd"*)
      case "$machine" in
        *"86") platform='freebsd32' ;;
        *"64") platform='freebsd64' ;;
      esac
      ;;
    "openbsd")
      case "$machine" in
        *"86") platform='openbsd32' ;;
        *"64") platform='openbsd64' ;;
      esac
      ;;
    "netbsd")
      case "$machine" in
        *"86") platform='netbsd32' ;;
        *"64") platform='netbsd64' ;;
      esac
      ;;
    "msys"*|"cygwin"*|"mingw"*|*"_nt"*|"win"*)
      case "$machine" in
        *"86") platform='win32' ;;
        *"64") platform='win64' ;;
      esac
      ;;
  esac
fi

if [ "x$platform" = "x" ]; then
  cat << 'EOM'
/=====================================\\
|      COULD NOT DETECT PLATFORM      |
\\=====================================/

Uh oh! We couldn't automatically detect your operating system. You can file a
bug here: https://github.com/benweissmann/getmic.ro

To continue with installation, please choose from one of the following values:

- freebsd32
- freebsd64
- linux-arm
- linux-arm64
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
  printf "Detected platform: %s\n" "$platform"
fi

TAG=$(githubLatestTag zyedidia/micro)

if [ "x$platform" = "xwin64" ] || [ "x$platform" = "xwin32" ]; then
  extension='zip'
else
  extension='tar.gz'
fi

printf "Latest Version: %s\n" "$TAG"
printf "Downloading https://github.com/zyedidia/micro/releases/download/v%s/micro-%s-%s.%s\n" "$TAG" "$TAG" "$platform" "$extension"

curl -L "https://github.com/zyedidia/micro/releases/download/v$TAG/micro-$TAG-$platform.$extension" > "micro.$extension"

case "$extension" in
  "zip") unzip -j "micro.$extension" -d "micro-$TAG" ;;
  "tar.gz") tar -xvzf "micro.$extension" "micro-$TAG/micro" ;;
esac

mv "micro-$TAG/micro" ./micro

rm "micro.$extension"
rm -rf "micro-$TAG"

cat <<-'EOM'

 __  __ _                  ___           _        _ _          _ _
|  \/  (_) ___ _ __ ___   |_ _|_ __  ___| |_ __  | | | ___  __| | |
| |\/| | |/ __| '__/ _ \   | || '_ \/ __| __/ _\ | | |/ _ \/ _  | |
| |  | | | (__| | | (_) |  | || | | \__ \ || (_| | | |  __/ (_| |_|
|_|  |_|_|\___|_|  \___/  |___|_| |_|___/\__\__,_|_|_|\___|\__,_(_)

Micro has been downloaded to the current directory.
You can run it with:

./micro

EOM
