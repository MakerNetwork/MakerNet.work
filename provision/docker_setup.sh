#!/usr/bin/env bash

###
# Set environmen values
environment()
{
  echo "* Setting env language... ******************************************** "

  # Virtual environment flag
  echo '# Set virtual environment flag' >> ~/.profile
  echo 'export VIRTUAL_DEV_ENV=true' >> ~/.profile

  # Language configuration
  echo '# Set locale configuration' >> ~/.profile
  echo 'export LC_ALL=en_US.UTF-8' >> ~/.profile
  echo 'export LANG=en_US.UTF-8' >> ~/.profile
  echo 'export LANGUAGE=en_US.UTF-8' >> ~/.profile
}

###
# Install Docker dependencies
docker()
{
  echo "* Updating system packages... **************************************** "
  sudo apt update && sudo apt upgrade -y

  echo "* Setting up Docker... *********************************************** "

  sudo apt-get install -y curl \
    ntp \
    ntpdate \
    ca-certificates \
    apt-transport-https \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88

  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce
  sudo usermod -a -G docker $USER

  sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

###
# Fetch configuration files
examples()
{
  echo "* Fetching example conf files... ************************************* "

  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/a6cfc84214503de09bf188c4d14f99a77c8c0641/setup.sh | sudo bash

  sudo mkdir -p /apps/makernet/config
  sudo ln -s /apps/makernet makernet
  cd makernet
  sudo cp example/env.example config/env
  sudo ln -s config/env .env

  sudo mkdir -p /apps/makernet/config/nginx
  sudo cp example/nginx.conf.example config/nginx/makernet.conf
}

docker_setup()
{
  environment
  docker
  examples
}

docker_setup "$@"

echo "Docker installation has finished. Now, reboot the system."
