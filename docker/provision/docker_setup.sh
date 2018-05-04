#!/usr/bin/env bash

# Set environmen values #######################################################

# Language configuration
echo '# Set locale configuration' >> ~/.bashrc
echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc
echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
echo 'export LANGUAGE=en_US.UTF-8' >> ~/.bashrc

echo "***************************************************"
echo 'Updating system packages... '
echo "***************************************************"
sudo apt update && sudo apt upgrade -y


echo "***************************************************"
echo 'Setting up Docker... '
echo "***************************************************"

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-compose
sudo usermod -a -G docker $USER

echo "Docker installation has finished. Now, reboot the system."