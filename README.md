# getmic.ro

[![Build Status](https://travis-ci.org/benweissmann/getmic.ro.svg?branch=master)](https://travis-ci.org/benweissmann/getmic.ro)

The fastest way to install [Micro](https://micro-editor.github.io/)

`curl https://getmic.ro | bash`

This script will install micro to the directory you're in. To install somewhere else (e.g. /usr/local/bin), cd there and make sure you can write to that directory, e.g. `cd /usr/local/bin; curl https://getmic.ro | sudo bash`

To verify the script, you can download it and checksum it. The sha256 checksum is `ab4a21a57cac640f7405da5971c6f9cbfb00208cf2bfc2ada8a0a5dde3563730`.

    curl -o getmicro.sh https://getmic.ro
    shasum -a 256 getmicro.sh # and check the output
    bash getmicro.sh
    
## Contributing

Thank you for contributing! We use the Github pull request workflow: fork this repo, make your changes, and then submit a pull request. There's a couple things you'll need to do to get your PR merged:

- Make sure all of the Travis CI tests pass. Travis CI will report test failures on the PR page once you open it.

- If you introduce new behavior, update the Travis CI tests to test that behavior.

- If you introduce new user-facing options or behavior, update this README to document that behavior.

If you're not sure how to do any of these things, feel free to open a PR with your work-in-progress and whatever questions you have!

## Acknowledgments:

- Micro, of course: https://micro-editor.github.io/

- Loosely based on the Chef curl|bash: https://docs.chef.io/install_omnibus.html

- ASCII art courtesy of figlet: http://www.figlet.org/
