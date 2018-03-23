#!/usr/bin/env bash

echo "***************************************************"
echo 'Setting laguage configuration... '
echo "***************************************************"
echo "\n" >>  ~/.profile
echo '# Set locale configuration' >> ~/.profile
echo 'export LC_ALL=en_US.UTF-8' >> ~/.profile
echo 'export LANG=en_US.UTF-8' >> ~/.profile
echo 'export LANGUAGE=en_US.UTF-8' >> ~/.profile
echo "\n" >>  ~/.profile
source .profile

echo "***************************************************"
echo 'Updating system packages... '
echo "***************************************************"
sudo apt update && sudo apt upgrade -y

echo "***************************************************"
echo 'Installing required extra packages... '
echo "***************************************************"
sudo apt install -y curl gnupg build-essential imagemagick libxml2 libxml2-dev libxslt1-dev libpq-dev

echo "***************************************************"
echo "Installing Node with NVM... "
echo "***************************************************"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install lts/*

echo "***************************************************"
echo "Installing Ruby with RVM... "
echo "***************************************************"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash
source /home/ubuntu/.rvm/scripts/rvm
rvm install ruby-2.4
rvm use ruby-2.4@global
gem update --system --no-ri --no-rdoc
gem update --no-ri --no-rdoc
rvm use ruby-2.4 --default

echo "***************************************************"
echo 'Removing unused software... '
echo "***************************************************"
rvm cleanup all
sudo apt autoremove
