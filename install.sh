#!/bin/sh
pip install --user mdv
pip install --user git+https://github.com/jeffkaufman/icdiff.git
pip install --user tldr
pip3 install --user commitizen
sudo cp git-cz /usr/bin
sudo chmod +x /usr/bin/git-cz
sudo apt-get install --yes jq httpie