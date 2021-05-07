#/bin/bash

# check if we're running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# environment variables
LC_ALL=C.UTF-8
PHP_PPA="ondrej/php"

if ! grep -q "^deb .*$PHP_PPA" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    # commands to add the ppa ...
    add-apt-repository ppa:ondrej/php
fi

# install all dev tools and php
sudo apt -y install git snapd openssl curl \
	wget gnupg2 gnupg-agent dirmngr cryptsetup scdaemon pcscd secure-delete hopenpgp-tools yubikey-personalization \
	php-common php-curl php-json php-mbstring php-mysql php-xml php-zip php-swoole

# gpg --card-edit should now work.

# install our gpg key
curl https://ghostzero.dev/pgp | gpg --import

# trust your key now with "gpg --edit-key 4320EBEFA0BB3240"

# install composer v2
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# install snap apps
sudo snap install phpstorm --classic
sudo snap install slack --classic
sudo snap install datagrip --classic
sudo snap install discord
