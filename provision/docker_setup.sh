#!/usr/bin/env bash

###
# Set environment values
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

  echo "* Setting up Docker Compose ****************************************** "

  sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

###
# Fetch configuration files
examples()
{
  echo "* Fetching example conf files... ************************************* "

  MAKERNET_PATH=${1:-/apps/makernet}

  mkdir -p "$MAKERNET_PATH/example"

  # MakerNet environment variables
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/9fdc68b0c23142ef6552e71b93728a0e7f64b518/env.example > "$MAKERNET_PATH/example/env.example"

  # nginx configuration
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/nginx_with_ssl.conf.example > "$MAKERNET_PATH/example/nginx_with_ssl.conf.example"
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/nginx.conf.example > "$MAKERNET_PATH/example/nginx.conf.example"

  # let's encrypt configuration
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/webroot.ini.example > "$MAKERNET_PATH/example/webroot.ini.example"

  # docker-compose
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/b16c719349a6d6b12ab0f07abaf2a736f4376500/docker-compose.yml > "$MAKERNET_PATH/docker-compose.yml"

  echo "* Placing basic configuration... ************************************* "

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
