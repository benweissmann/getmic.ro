# getmic.ro

The fastest way to install [Micro](https://micro-editor.github.io/)

`curl https://getmic.ro | bash`

This script will install micro to the directory you're in. To install somewhere else (e.g. /usr/local/bin), cd there and make sure you can write to that directory, e.g. `cd /usr/local/bin; curl https://getmic.ro | sudo bash`

To verify the script, you can download it and checksum it. The sha256 checksum is `7753b7dc6c879cf0097c449840948299ea8236997639c19f6a2cb66d187d4c76`.

    curl -o getmicro.sh https://getmic.ro
    shasum -a 256 getmicro.sh # and check the output
    bash getmicro.sh

## Acknowledgments:

- Micro, of course: https://micro-editor.github.io/

- Loosely based on the Chef curl|bash: https://docs.chef.io/install_omnibus.html

- ASCII art courtesy of figlet: http://www.figlet.org/
