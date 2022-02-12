#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

shell="${@-sh}"

buildsomething() {
  name="$1"
  url="$2"
  install="${3:-n}"
  extrapkgs="${4:-}"
  
  sudo apt-get install -y gcc make binutils autoconf automake autotools-dev curl tar gzip libtool curl $extrapkgs
  
  rm -rf $name* 2>/dev/null || true # cleanup
  
  #echo "[STATUS:] Downloading $name from $url"
  #curl -o "$name.tar.gz" "$url"
  
  echo
  echo "[STATUS:] Extracting $name"
  tar -xvf "$SCRIPT_DIR/altshells/$name.tar.gz" -C "$SCRIPT_DIR/.."
  cd $name*
  
  if [ "x$install" = "xmeson" ] ; then
    echo
    echo "[STATUS:] Configuring $name with meson"
    meson build -Db_sanitize=address,undefined -Dauto_features=enabled
    meson configure build --buildtype release
    
    echo
    echo "[STATUS:] Building $name with ninja"
    ninja -C build
  else
    echo
    echo "[STATUS:] Configuring $name"
    ./configure --prefix=/usr/local

    threadcount=$(nproc 2>/dev/null || true)
  
    echo
    echo "[STATUS:] Building $name"
    make -j${threadcount:-4}
    
    if [ "x$install" = "xy" ] ; then
      echo
      echo "[STATUS:] Installing $name"
      sudo PREFIX=/usr/local make -j${threadcount:-4} install
    fi
  fi
  
  cd ..
  
  if [ "x$install" = "xy" ] ; then
    rm -rf $name* 2>/dev/null || true # cleanup
  fi
}

if [ "x$shell" = "xgash" ] ; then
  buildsomething gash "http://download.savannah.nongnu.org/releases/gash/gash-0.2.0.tar.gz" y guile-2.2-dev
elif [ "x$shell" = "xmrsh" ] ; then
  buildsomething mrsh "https://github.com/emersion/mrsh/archive/cd3c3a48055ab4085d83f149ff4b4feba40b40cb.tar.gz" meson 'meson ninja-build'
  echo "[STATUS:] Installing mrsh"
  
  echo cp -f ./mrsh*/build/mrsh ./mrsh*/build/lib* /usr/local/bin/
  sudo cp -f ./mrsh*/build/mrsh ./mrsh*/build/lib* /usr/local/bin/
  
  echo
  rm -rf mrsh* 2>/dev/null || true # cleanup
elif [ "x$shell" = "xtoybox toysh" ] ; then
  # buildsomething toybox "http://landley.net/toybox/downloads/toybox-0.8.6.tar.gz" y
  echo "[STATUS:] Installing toybox"
  echo cp ./ci/altshells/toybox-x86_64 /usr/local/bin/toybox
  echo
  sudo cp ./ci/altshells/toybox-x86_64 /usr/local/bin/toybox
elif [ "x$shell" = "xoil" ] ; then
  buildsomething oil "https://www.oilshell.org/download/oil-0.9.7.tar.gz" y
elif [ "x$shell" = "xbusybox sh" ] ; then
  sudo apt-get install -y busybox
else
  sudo apt-get install -y "$shell"
fi

./ci/runTest.sh "$shell"

