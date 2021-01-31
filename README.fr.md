# getmic.ro

> Don't understand french ? speak english ? here's the [english README](./README.md) !

![Test](https://github.com/benweissmann/getmic.ro/workflows/Test/badge.svg)

Le moyen le plus rapide d'installer [Micro](https://micro-editor.github.io/)

`curl https://getmic.ro | bash`

Ce script installera micro dans le dossier dans lequel vous vous trouvez. Pour l'installer ailleurs (p.e. /usr/local/bin), déplacez vous y (avec `cd`) et assurez-vous d'avoir les droits d'écriture du dossier, p.e. `cd /usr/local/bin; curl https://getmic.ro | sudo bash`

> NOTE : micro ainsi que le script de téléchargement sont en anglais. Si vous ne comprenez pas quelque chose, n'hésitez pas à vous renseigner sur [ce wiki français](https://wiki.ubuntu-fr.org/micro) !

## Utilisation avancée

Vous pouvez aussi faire d'autres choses avec getmic.ro.

### Utiliser un autre shell POSIX

Même si getmic.ro est essentiellement testé avec bash, il devrait être compatible avec n'importe quel autre script compatible POSIX (on essaye avec zsh, dash, ksh, and busybox). Si vous n'avzez pas `bash`, vous pouvez tout simplement entrer :

`curl https://getmic.ro | sh`

### Vérifier la somme de contrôle (checksum)

Pour vérifer le script, vous pouvez le télécharger et chercher sa somme de contrôle. Le sha256 est `43fa64b603c88bb2cef003802572b9afcebc52742e909b50abc6e73abdb1e829`.

    curl -o getmicro.sh https://getmic.ro
    shasum -a 256 getmicro.sh # vérifiez ici la sortie
    bash getmicro.sh

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
