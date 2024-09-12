# getmic.ro

> Don't understand french ? speak english ? here's the [english README](./README.md) !

![Test](https://github.com/benweissmann/getmic.ro/workflows/Test/badge.svg)

Le moyen le plus rapide d'installer [Micro](https://micro-editor.github.io/)

```Bash
# installation locale rien que pour vous
curl https://getmic.ro | sh
```

Ou:

```Bash
# installation locale rien que pour vous
wget -O- https://getmic.ro | sh
```

Ce script installera micro dans le dossier dans lequel vous vous trouvez. Pour l'installer ailleurs (p.e. /usr/local/bin), déplacez vous y (avec `cd`) et assurez-vous d'avoir les droits d'écriture du dossier, p.e. `cd /usr/local/bin; curl https://getmic.ro | sudo bash`:

```Bash
# installation globale pour tout le monde
cd /usr/bin
curl https://getmic.ro | sudo sh
```

Ou:

```Bash
# installation globale pour tout le monde
su - root -c 'cd /usr/bin; wget -O- https://getmic.ro sh'
```

> NOTE : micro ainsi que le script de téléchargement sont en anglais. Si vous ne comprenez pas quelque chose, n'hésitez pas à vous renseigner sur [ce wiki français](https://wiki.ubuntu-fr.org/micro) !

## Utilisation avancée

Vous pouvez aussi faire d'autres choses avec getmic.ro. La documentation Français est incomplète. Si possible, veuillez vous référer à la [documentation en anglais](./README.md).

* `GETMICRO_HTTP=<COMMAND ...ARGS>`
    + Exemple: `curl https://getmic.ro | GETMICRO_HTTP="curl -L" sh`
    + Exemple: `wget -O- https://getmic.ro | GETMICRO_HTTP="wget -O-" sh`
* `GETMICRO_PLATFORM=[freebsd32 | freebsd64 linux-arm | linux-arm64 | linux32 | linux64 | linux64-static | netbsd32 | netbsd64 | openbsd32 | openbsd64 | osx | win32 | win64]`
    + Par défaut: `GETMICRO_PLATFORM=n`
    + Par exemple, si votre libc est musl, alors: `https://getmic.ro | GETMICRO_PLATFORM=linux64-static sh`
* `GETMICRO_REGISTER=[y | n]`
    + Ceci contrôle s'il faut utiliser `update-alternatives` ou non.
        - y => oui
        - n => non
    + Exemple: `curl https://getmic.ro | GETMICRO_REGISTER=n sh`
    + Exemple: `curl https://getmic.ro | GETMICRO_REGISTER=y sh`

Exemple: 

```Bash
wget -O- https://getmic.ro | GETMICRO_HTTP="wget -O-" GETMICRO_PLATFORM=linux32 GETMICRO_REGISTER=y sh
```

### Vérifier la somme de contrôle (checksum)

Pour vérifer le script, vous pouvez le télécharger et chercher sa somme de contrôle. Le sha256 est `1e0f552009a848cbfd0a2f2fdd9708850e8224fc7cc5942ac4d23cf32bfb1eed`.

```Bash
gmcr="$(curl https://getmic.ro)" && [ $(echo "$gmcr" | shasum -a 256 | cut -d' ' -f1) = 1e0f552009a848cbfd0a2f2fdd9708850e8224fc7cc5942ac4d23cf32bfb1eed ] && echo "$gmcr" | sh
```

Ou:

```Bash
# 1. Vérifiez manuellement que cette sortie 1e0f552009a848cbfd0a2f2fdd9708850e8224fc7cc5942ac4d23cf32bfb1eed
curl https://getmic.ro | shasum -a 256

# 2. Si #1 a réussi, exécutez getmicro
curl https://getmic.ro | sh
```

## Contribution

Merci de contribuer à getmic.ro ! Pour ça, on utilise les pull-requests de Github : forkez ce dépo, appliquez vos changements et demandez un pull-request. Voici quelques choses à faire avant que votre PR soit validé :

- Assurez vous que tous les tests passent. Github Action raportera les erreurs sur la page du PR une fois ce dernier ouvert.

- Si vous introduisez de nouvelles fonctionnallités, corrigez les tests de Github Action (dans [`.github/workflows/test.yml`](https://github.com/benweissmann/getmic.ro/blob/master/.github/workflows/test.yml)) afin qu'elles soient testées.

- Si vous introduisez de nouvelles options ou fonctionnalités utilisateures, mettez à jour les fichiers README pour documenter les changements (ne traduisez pas si vous ne connaissez pas la langue du fichier).

Si vous n'êtes pas sûrs de la façon de réaliser l'un de ces points, n'hésitez pas à ouvrir un PR en cours de travail et à poser vous questions !

## Remerciements

- Micro, bien sur : https://micro-editor.github.io/

- Entièrement basé sur curl|bash : https://docs.chef.io/install_omnibus.html

- ASCII arts faits avec figlet : http://www.figlet.org/
