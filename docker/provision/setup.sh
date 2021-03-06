#!/bin/bash

###
# Set environment values
environment()
{
  echo "* Setting env language... ******************************************** "

  # Language configuration
  echo '# Set locale configuration' >> ~/.profile
  echo 'export LC_ALL=en_US.UTF-8' >> ~/.profile
  echo 'export LANG=en_US.UTF-8' >> ~/.profile
  echo 'export LANGUAGE=en_US.UTF-8' >> ~/.profile
}

###
# Tune-up the system settings
system_tuning()
{
  echo "* Tunning up the system... ******************************************* "

  sudo echo '## Redis tune-up' >> /etc/sysctl.conf
  sudo echo '# Allow background save on low memory conditions' >> /etc/sysctl.conf
  sudo echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf

  sudo sed -i 's/exit 0/## Redis tune-up/g' /etc/rc.local
  sudo echo '# Reduce latency and memory usage' >> /etc/rc.local
  sudo echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local
  sudo echo 'exit 0' >> /etc/rc.local
  sudo chmod +x /etc/rc.local

  sudo echo '## ElasticSearch tune-up' >> /etc/sysctl.conf
  sudo echo '# Increase max virtual memory areas' >> /etc/sysctl.conf
  sudo echo 'vm.max_map_count = 262144' >> /etc/sysctl.conf
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
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/4f8e027e5ee5973e7026bedd804c8ff46678c10e/env > "$MAKERNET_PATH/example/env"

  # nginx configuration
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/4f8e027e5ee5973e7026bedd804c8ff46678c10e/nginx_ssl.conf > "$MAKERNET_PATH/example/nginx_ssl.conf"
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/4f8e027e5ee5973e7026bedd804c8ff46678c10e/nginx.conf > "$MAKERNET_PATH/example/nginx.conf"

  # let's encrypt configuration
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/dd8121aec54df2c95dd4a7454f9c45472c00e767/webroot.ini > "$MAKERNET_PATH/example/webroot.ini"

  # docker-compose
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/dd8121aec54df2c95dd4a7454f9c45472c00e767/docker-compose.yml > "$MAKERNET_PATH/docker-compose.yml"

  echo "* Placing basic configuration... ************************************* "

  sudo mkdir -p /apps/makernet/config
  sudo ln -s /apps/makernet makernet
  cd makernet
  sudo cp example/env config/env
  sudo ln -s config/env .env

  sudo mkdir -p /apps/makernet/config/nginx
  sudo cp example/nginx.conf config/nginx/makernet.conf
}

docker_setup()
{
  environment
  system_tuning
  docker
  examples
}

# Make sure only root can run our script
if [[ "$(id -u)" -ne 0 ]]
 then
   echo "This script must be run as root" 1>&2
   exit 1
fi

docker_setup "$@"

echo "Docker installation has finished. Now, reboot the system."
