#!/bin/bash

# check if we're running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# environment variables
LC_ALL=C.UTF-8
PHP_PPA="ondrej/php"

mkdir -p /etc/apt/sources.list.d/

if ! grep -q "^deb .*$PHP_PPA" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    # commands to add the ppa ...
    add-apt-repository ppa:ondrej/php
fi

# install all dev tools and php
sudo apt -y install zsh git snapd openssl curl build-essential \
	wget gnupg2 gnupg-agent dirmngr cryptsetup scdaemon pcscd secure-delete hopenpgp-tools yubikey-personalization \
	php-common php-curl php-json php-mbstring php-mysql php-xml php-zip php-swoole php-gd php-imagick \
	php-redis redis-server mariadb-server flameshot

# todo add zsh installer
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# "gpg --card-edit" should now work.

# install our gpg key
curl https://ghostzero.dev/gpg | gpg --import

# add our own package registry
echo "deb [arch=amd64 trusted=yes] https://deb.ghostzero.dev/ubuntu $(lsb_release -cs) main" | \
	sudo tee /etc/apt/sources.list.d/ghostzero.list > /dev/null

sudo apt update

# trust your key now with "gpg --edit-key 4320EBEFA0BB3240"

# install composer v2
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# install composer packages globally
composer global require ghostzero/maid

# install snap apps
sudo snap install phpstorm --classic
sudo snap install slack --classic
sudo snap install datagrip --classic
sudo snap install discord
