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
  latestJSON="$( eval "$http 'https://api.github.com/repos/$1/releases/latest'" 2>/dev/null )" || true
  
  versionNumber=''
  if ! echo "$latestJSON" | grep 'API rate limit exceeded' >/dev/null 2>&1 ; then
    if ! versionNumber="$( echo "$latestJSON" | grep -oEm1 '[0-9]+[.][0-9]+[.][0-9]+' - 2>/dev/null )" ; then
      versionNumber=''
    fi
  fi
  
  if [ "${versionNumber:-x}" = "x" ] ; then
    # Try to fallback to previous latest version detection method if curl is available
    if command -v curl >/dev/null 2>&1 ; then
      if finalUrl="$( curl "https://github.com/$1/releases/latest" -s -L -I -o /dev/null -w '%{url_effective}' 2>/dev/null )" ; then
        trimmedVers="${finalUrl##*v}"
        if [ "${trimmedVers:-x}" != "x" ] ; then
          echo "$trimmedVers"
          exit 0
        fi
      fi
    fi
    
    cat 1>&2 << 'EOA'
/=====================================\\
|     FAILED TO HTTP DOWNLOAD FILE     |
\\=====================================/

Uh oh! We couldn't download needed internet resources for you. Perhaps you are
 offline, your DNS servers are not set up properly, your internet plan doesn't
 include GitHub, or the GitHub servers are down?

EOA
    exit 1
  else
    echo "$versionNumber"
  fi
}

if [ "${GETMICRO_HTTP:-x}" != "x" ]; then
  http="$GETMICRO_HTTP"
elif command -v curl >/dev/null 2>&1 ; then
  http="curl -L"
elif command -v wget >/dev/null 2>&1 ; then
  http="wget -O-"
else
  cat 1>&2 << 'EOA'
/=====================================\\
|     COULD NOT FIND HTTP PROGRAM     |
\\=====================================/

Uh oh! We couldn't find either curl or wget installed on your system.

To continue with installation, you have two options--A or B.

A. Install either wget or curl on your system. You may need to run `hash -r`.

B. Define GETMICRO_HTTP to be a command (with arguments deliminated by spaces)
    that both follows HTTP redirects AND prints the fetched content to stdout.

For examples of option B, getmicro uses the below values for wget and curl:

  $ curl https://getmic.ro | GETMICRO_HTTP="curl -L" sh

  $ wget -O- https://getmic.ro | GETMICRO_HTTP="wget -O-" sh

EOA
  exit 1
fi

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

if [ "${platform:-x}" = "x" ]; then
  cat 1>&2 << 'EOM'
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

  $ curl https://getmic.ro | GETMICRO_PLATFORM=linux64 sh

EOM
  exit 1
else
  echo "Detected platform: $platform"
fi

TAG=$(githubLatestTag zyedidia/micro)

if command -v grep >/dev/null 2>&1 ; then
  if ! echo "v$TAG" | grep -E '^v[0-9]+[.][0-9]+[.][0-9]+$' >/dev/null 2>&1 ; then
      cat 1>&2 << 'EOM'
/=====================================\\
|         INVALID TAG RECIEVED         |
\\=====================================/

Uh oh! We recieved an invalid tag and cannot be sure that the tag will not break
 this script.

Please open an issue on GitHub at https://github.com/benweissmann/getmic.ro with
 the invalid tag included:

EOM
    echo "> $TAG" 1>&2
    exit 1
  fi
fi

if [ "${platform:-x}" = "win64" ] || [ "${platform:-x}" = "win32" ]; then
  extension='zip'
else
  extension='tar.gz'
fi

if [ "${platform:-x}" = "linux64" ]; then
  # Detect musl libc (source: https://stackoverflow.com/a/60471114)
  libc=$(ldd /bin/ls | grep 'musl' | head -1 | cut -d ' ' -f1)
  if [ -n "$libc" ]; then
    # Musl libc; use the staticly-compiled versioon
    platform='linux64-static'
  fi
fi

echo "Latest Version: $TAG"
echo "Downloading https://github.com/zyedidia/micro/releases/download/v$TAG/micro-$TAG-$platform.$extension"

eval "$http 'https://github.com/zyedidia/micro/releases/download/v$TAG/micro-$TAG-$platform.$extension'" > "micro.$extension"

case "$extension" in
  "zip") unzip -j "micro.$extension" -d "micro-$TAG" ;;
  "tar.gz") tar -xvzf "micro.$extension" "micro-$TAG/micro" ;;
esac

mv "micro-$TAG/micro" ./micro

rm "micro.$extension"
rm -rf "micro-$TAG"

if command -v alternatives >/dev/null 2>&1 ; then
  # RHEL family(?)
  altcmd="alternatives"
elif command -v update-alternatives >/dev/null 2>&1 ; then
  # Debian family(?)
  altcmd="update-alternatives"
fi

if [ "${altcmd:-x}" != "x" ] ; then
  wrkdir="$(pwd)"
  
  isatty=0
  if [ -t 0 ] || [ -t 2 ] ; then # When piping into get micro, e.g. `curl https://getmic.ro | `
    isatty=1
  fi
  if [ "${GETMICRO_REGISTER:-x}" = "n" ] || [ "${GETMICRO_REGISTER:-x}" = "N" ] ; then
    doRegister="n"
  elif [ "${GETMICRO_REGISTER:-x}" = "y" ] || [ "${GETMICRO_REGISTER:-x}" = "Y" ] ; then
    doRegister="y"
  elif [ $isatty -eq 1 ] ; then
    cat 1>&2 << 'EOM'
/=====================================\\
|     update-alternatives detected     |
\\=====================================/

getmicro can use update-alternatives to register micro as a system text editor.
For example, this will allow `crontab -e` open the cron file with micro.

To avoid this prompt in the future, define the GETMICRO_REGISTER variable. E.x:

  $ curl https://getmic.ro | GETMICRO_REGISTER=y sh
  
Many people find it useful to make micro available on the PATH. One way to do
 this is to enter a root shell and run `cd /usr/bin` prior to installation.

EOM
    cpt="Register '$wrkdir/micro' with update-alternatives [y/n]: "
    if command -v printf >/dev/null 2>&1 ; then
      printf '%s' "$cpt" 1>&2
    else
      # Wrapping this in eval helps this script to pass shellcheck
      eval '( echo -n "$cpt" 2>/dev/null || echo -e "$cpt"'\''\c'\'' 2>/dev/null || echo "$cpt" ) 1>&2'
    fi
    if command -v head >/dev/null 2>&1 ; then
      # needed when piping curl into sh as its a subshell so one must reopen the tty
      doRegister="$(head -n1 /dev/tty)"
    elif command -v sed >/dev/null 2>&1 ; then
      doRegister="$(sed 1q)"
    else
      read -r doRegister
    fi
    echo # add new line after long message and user input for prettier output
  else
    # default to not installing
    doRegister="n"
  fi
  
  if [ "${doRegister:-x}" = "y" ] ; then
    if [ -w /etc/alternatives ] ; then # if we have write permission to /etc/alternatives
      # hope we are effectively running as root
      echo "Installing '$wrkdir/micro' as /usr/bin/editor..."
      $altcmd --install /usr/bin/editor editor "$wrkdir/micro" 80

      if command -v git >/dev/null 2>&1 ; then
        # set the absolute lowest priority default value of core.editor to be /usr/bin/editor
        # note that this git config will error out if the config key is already set
        if git config --system --path core.editor /usr/bin/editor >/dev/null 2>&1 ; then
          echo "Configuring git to use /usr/bin/editor as the default core editor..."
        fi
      fi

      if [ -w /etc/environment ] && ! grep -qi '^EDITOR=' /etc/environment ; then
        # set the absolute lowest priority default value of EDITOR to be /usr/bin/editor
        echo "Configuring /etc/environment to use /usr/bin/editor as the default text EDITOR..."
        echo 'EDITOR=/usr/bin/editor' >> /etc/environment 
      fi
      echo # pretty print new line to separate sections
    else
      cat 1>&2 << 'EOM'
/=====================================\\
|    PLEASE READ THIS ERROR MESSAGE    |
\\=====================================/

There is a very easy fix for this error, as explained below. We couldn't run
 update-alternatives due to insufficient privileges.

To continue, try running getmicro as root or another privileged user. Examples:

  $ curl https://getmic.ro | sudo sh
  
Or:

  $ su - root -c "wget -O- https://getmic.ro | sh"

EOM
      exit 1
    fi
  fi
fi

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
