#!/bin/bash

# STRICT MODE AND ERROR IMPROVEMENTS (must be at top of script)
# https://olivergondza.github.io/2019/10/01/bash-strict-mode.html
set -euo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'
### END


# ADD DEFAULT USER
useradd --create-home --shell '/bin/bash' dev
usermod -aG root dev

echo '%root ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/root
chmod 440 /etc/sudoers.d/root
### END


# LATEST VIM
# https://github.com/vim/vim
git clone https://github.com/vim/vim.git
cd vim/src
make
make install
cd ../..
### END


# DUMB-INIT
# https://github.com/Yelp/dumb-init
curl -qfsSL https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb -o dumb-init.deb
apt-get install -y ./dumb-init.deb
# END


# TASK (task runner)
# https://taskfile.dev/#/usage
curl -sL https://taskfile.dev/install.sh | sh
mv ./bin/task /usr/local/bin
### END


# ATLANTIS USER
useradd --create-home --shell '/bin/sh' atlantis
usermod -aG root atlantis
chown atlantis:root /home/atlantis/
chmod g=u /home/atlantis/
chmod g=u /etc/passwd
### END


# ATLANTIS
# https://runatlantis.io
curl -qfsSL https://github.com/runatlantis/atlantis/releases/download/v0.15.0/atlantis_linux_amd64.zip -o atlantis.zip
unzip atlantis.zip
mv ./atlantis /usr/bin
chown atlantis:root /usr/bin/atlantis
setcap "cap_net_bind_service=+ep" /usr/bin/atlantis
set -- gosu atlantis "$@"
### END


# # TERRRAGRUNT 
# # https://terragrunt.gruntwork.io/
# curl -qfsSL https://github.com/gruntwork-io/terragrunt/releases/download/v0.25.1/terragrunt_linux_amd64 -o terragrunt
# chmod +x terragrunt
# mv terragrunt /usr/local/bin
# ### END


# DIRENV 
# https://direnv.net/
curl -qfsSL https://github.com/direnv/direnv/releases/download/v2.22.0/direnv.linux-amd64 -o direnv
chmod +x direnv
mv direnv /usr/local/bin
### END


# OFFICIAL AWS-CLI V2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
### END


# AWS-VAULT
# https://github.com/99designs/aws-vault/blob/master/USAGE.md
curl -qfsSL https://github.com/99designs/aws-vault/releases/download/v6.0.1/aws-vault-linux-amd64 -o aws-vault
chmod +x aws-vault
mv aws-vault /usr/local/bin
### END


# AWS-IAM-AUTHENTICATOR
# https://docs.aws.amazon.com/eks/latest/userguide/managing-auth.html
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/aws-iam-authenticator
chmod +x aws-iam-authenticator
mv aws-iam-authenticator /usr/local/bin
### END


# CHAMBER
# https://aws.amazon.com/blogs/mt/the-right-way-to-store-secrets-using-parameter-store/
curl -s https://packagecloud.io/install/repositories/segment/chamber/script.deb.sh | sudo bash
apt-get install -y chamber
### END


# STARSHIP (PROMPT) 
# https://starship.rs/
curl -fsSL https://starship.rs/install.sh | bash -s -- --yes
### END


# kubectl
# https://helm.sh/
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
### END


# goofys
# https://github.com/kahing/goofys
# Allows mounting an S3 bucket to a path in the container
curl -qfsSL https://github.com/kahing/goofys/releases/latest/download/goofys -o goofys
chmod +x ./goofys
mv ./goofys /usr/local/bin/goofys
### END


# tfenv (tfexport)
# https://github.com/cloudposse/tfenv
# NOTE: We are using two different tools called tfenv, this one get renamed to tfexport
curl -qfsSL https://github.com/cloudposse/tfenv/releases/download/0.4.0/tfenv_linux_amd64 -o tfexport
chmod +x ./tfexport
mv ./tfexport /usr/local/bin/tfexport
### END


# Terraform version manager - tfenv (tfenv) 
# https://github.com/tfutils/tfenv
# NOTE: We are using two different tools called tfenv, this one keeps the name tfenv
mkdir /home/version-managers
git clone https://github.com/tfutils/tfenv.git /home/version-managers/.tfenv
ln -s /home/version-managers/.tfenv/bin/* /usr/local/bin
### END


# Terragrunt version manager - tgenv
# https://github.com/cunymatthieu/tgenv
# NOTE: We are using two different tools called tfenv, this one keeps the name tfenv
git clone https://github.com/cunymatthieu/tgenv.git /home/version-managers/.tgenv
ln -s /home/version-managers/.tgenv/bin/* /usr/local/bin
chmod -R 777 /home/version-managers
### END


# Helm
# https://helm.sh/
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
### END


# INITIALIZE PASS
pass init default_pgp_key
### END


# GO
curl -qfsSL https://golang.org/dl/go1.15.2.linux-amd64.tar.gz -o go.tar.gz
tar -C /usr/local -xzf go.tar.gz
export PATH=$PATH:/usr/local/go/bin
### END


# terragrunt-atlantis-config
# https://github.com/transcend-io/terragrunt-atlantis-config
cd && GO111MODULE=on go get github.com/transcend-io/terragrunt-atlantis-config@master && cd -
### END


# PRE-COMMIT - TF-DOCS - TFLINT - TFSEC
pip3 install pre-commit
curl -L "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E "https://.+?-linux-amd64")" > terraform-docs && chmod +x terraform-docs && sudo mv terraform-docs /usr/bin/
curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip && unzip tflint.zip && rm tflint.zip && sudo mv tflint /usr/bin/
env GO111MODULE=on go get -u github.com/liamg/tfsec/cmd/tfsec

ls -la /usr/local/bin


# CLEAN UP
source ./cleanup.sh
### END
