#!/bin/sh

# Ce script installe micro.
#
# TODO: change url below to french file one
# Installation rapide : `curl https://getmic.ro | bash`
#
# Ce script va installer micro dans le répertoire courant. Pour l'installer
# ailleurs (par ex. dans /usr/loca/bin), déplacez vous y avec cd et vérifiez vos
# droits d'écriture, par ex. `cd /usr/local/bin ; curl https://getmic.ro | bash`
# TODO: change url upper to french file one
# 
# Vous avez un bug ? Rapportez le à https://github.com/benweissmann/getmic.ro
# (rapport de bugs en anglais)
#
# Remerciements:
#   - Micro, bien spur : https://micro-editor.github.io/
#   - Entièrement basé sur curl|bash : https://docs.chef.io/install_omnibus.html
#   - ASCII arts faits avec figlet : http://www.figlet.org/

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
/=================================================\\
|      IMPOSSIBLE DE DECTECTER LA PLATEFORME      |
\\=================================================/

Oh oh ! Nous n'avons pas pu détecter automatiquement votre système d'exploitation.
rapports de bugs ici : https://github.com/benweissmann/getmic.ro

Pour continuer l'installation, veuillez choisir une des propositions suivantes :

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

Exportez votre choix dans la variable d'environnement GETMICRO_PLATFORM,
puis ré-exécutez ce script.

Par exemple :

  $ export GETMICRO_PLATFORM=linux64
  $ curl https://getmic.ro | bash

EOM
# TODO: change url 3 lines upper to french file one
  exit 1
else
  printf "Plateforme détectée : %s\n" "$platform"
fi

TAG=$(githubLatestTag zyedidia/micro)

if [ "x$platform" = "xwin64" ] || [ "x$platform" = "xwin32" ]; then
  extension='zip'
else
  extension='tar.gz'
fi

printf "Dernière version : %s\n" "$TAG"
printf "Téléchargement de https://github.com/zyedidia/micro/releases/download/v%s/micro-%s-%s.%s\n" "$TAG" "$TAG" "$platform" "$extension"

curl -L "https://github.com/zyedidia/micro/releases/download/v$TAG/micro-$TAG-$platform.$extension" > "micro.$extension"

case "$extension" in
  "zip") unzip -j "micro.$extension" -d "micro-$TAG" ;;
  "tar.gz") tar -xvzf "micro.$extension" "micro-$TAG/micro" ;;
esac

mv "micro-$TAG/micro" ./micro

rm "micro.$extension"
rm -rf "micro-$TAG"

cat <<-'EOM'

 __  __ _                            __ _    __   ___           _        _ _   __   _
|  \/  (_) ___ _ __ ___     __ _    /_/| |_ /_/  |_ _|_ __  ___| |_ __ _| | | /_/  | |
| |\/| | |/ __| '__/ _ \   / _` |  / _ \ __/ _ \  | || '_ \/ __| __/ _` | | |/ _ \ | |
| |  | | | (__| | | (_) | | (_| | |  __/ ||  __/  | || | | \__ \ || (_| | | |  __/ |_|
|_|  |_|_|\___|_|  \___/   \__,_|  \___|\__\___| |___|_| |_|___/\__\__,_|_|_|\___| (_)

Micro a été téléchargé dans le dossier actuel !
Vous pouvez le lancez avec :

./micro

EOM
