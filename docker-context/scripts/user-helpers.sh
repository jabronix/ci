#!/bin/bash

# NODE VERSION MANAGER (NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true

nvm install --lts
nvm use --lts
### END


# SERVERLESS FRAMEWORK
npm install -g serverless
### END


# CLEAN UP
sudo apt-get clean || true
sudo apt-get autoclean || true
sudo apt-get autoremove || true
sudo rm -rf /home/temp || true
rm -f ~/cleanup.sh
rm -f ~/user-helpers.sh
rm -rf ~/.ssh
### END
