#!/bin/bash
echo "Install nodejs"
curl https://raw.githubusercontent.com/creationix/nvm/v0.13.1/install.sh | bash
source ~/.bash_profile
nvm install 0.12
nvm alias default 0.12
nvm use default
