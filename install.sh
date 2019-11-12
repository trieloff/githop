#!/bin/sh
pip install --user mdv tldr commitizen httpie
pip install --user git+https://github.com/jeffkaufman/icdiff.git
sudo cp git-cz /usr/bin
sudo chmod +x /usr/bin/git-cz
sudo apt-get install --yes jq less
