#!/bin/bash

# STRICT MODE AND ERROR IMPROVEMENTS (must be at top of script)
# https://olivergondza.github.io/2019/10/01/bash-strict-mode.html
set -euo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'
### END

# NEED THIS TO ADD AND VALIDATE REPOS
apt-get update -y
apt-get install --no-install-recommends -y \
gnupg2 \
software-properties-common 
### END


# INSTALL PACKAGES
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
add-apt-repository ppa:rmescandon/yq

apt-get update -y

apt-get install --no-install-recommends -y \
    zsh \
    bash \
    gosu \
    bash-completion \
    curl \
    figlet \
    file \
    unzip \
    wget \
    git \
    libncurses5-dev \
    libncursesw5-dev \
    build-essential \
    ca-certificates \
    sudo \
    python3 \
    python3-pip \
    git-lfs \
    openssl \
    nano \
    uidmap \
    iptables \
    jq \
    yq \
    pass \
    gawk \
    openssh-client
### END


# CLEAN UP
source ./cleanup.sh
### END
