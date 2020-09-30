#!/bin/bash

# NODE VERSION MANAGER (NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true

nvm install --lts
### END


# SERVERLESS FRAMEWORK
npm install -g serverless
### END


# PRE-COMMIT HOOK
pip3 install pre-commit checkov
curl -L "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E "https://.+?-linux-amd64")" > terraform-docs && chmod +x terraform-docs && sudo mv terraform-docs /usr/bin/
curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip && unzip tflint.zip && rm tflint.zip && sudo mv tflint /usr/bin/
env GO111MODULE=on go get -u github.com/liamg/tfsec/cmd/tfsec
###


# CLEAN UP
sudo apt-get clean || true
sudo apt-get autoclean || true
sudo apt-get autoremove || true
sudo rm -rf /home/temp || true
rm -f ~/cleanup.sh
rm -f ~/user-helpers.sh
rm -rf ~/.ssh
### END
