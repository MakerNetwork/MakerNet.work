#!/usr/bin/env zsh

###
# Set user  configuration
set_user_config() {
  echo "Setting ´vagrant´ user profile configuration"

  # Virtual environment flag
  echo -e '\n\n# Set virtual environment flag' >> ~/.profile
  echo -e 'export VIRTUAL_DEV_ENV=true\n' >> ~/.profile

  # Language configuration
  echo -e '\n# Set locale configuration' >> ~/.profile
  echo 'export LC_ALL=en_US.UTF-8' >> ~/.profile
  echo 'export LANG=en_US.UTF-8' >> ~/.profile
  echo -e 'export LANGUAGE=en_US.UTF-8\n' >> ~/.profile

  # Switch to project path after login
  echo -e '\n# Navigate to /vagrant after login' >> ~/.profile
  echo -e 'cd /vagrant\n' >> ~/.profile
}

###
# Tune-up the system settings
system_tuning()
{
  echo "Tunning up the system"

  sudo echo -e "\n## Redis tune-up" >> /etc/sysctl.conf
  sudo echo '# Allow background save on low memory conditions' >> /etc/sysctl.conf
  sudo echo -e "vm.overcommit_memory = 1\n" >> /etc/sysctl.conf

  sudo touch /etc/rc.local
  sudo echo '## Redis tune-up' >> /etc/rc.local
  sudo echo '# Reduce latency and memory usage' >> /etc/rc.local
  sudo echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local
  sudo echo -e "\n\n"
  sudo echo -e "exit 0\n" >> /etc/rc.local
  sudo chmod +x /etc/rc.local

  sudo echo -e "\n## ElasticSearch tune-up" >> /etc/sysctl.conf
  sudo echo '# Increase max virtual memory areas' >> /etc/sysctl.conf
  sudo echo -e "vm.max_map_count = 262144\n" >> /etc/sysctl.conf
}

###
# Install Ruby Version Manager
install_rvm() {
  echo 'Installing RVM'
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  \curl -sSL https://get.rvm.io | bash
  source $HOME/.rvm/scripts/rvm
  rvm get head
}

###
# Install Matz Ruby Interpreter
install_ruby() {
  echo 'Installing Ruby'
  sudo apt-get install -y libxml2-dev libxslt1-dev libpq-dev libidn11-dev
  rvm install ruby-2.4.4
  rvm use ruby-2.4.4@global
  gem update --system --no-ri --no-rdoc
  gem update --no-ri --no-rdoc
  rvm use ruby-2.4.4 --default
  rvm cleanup all
}

###
# Install Node Version Manager
install_nvm() {
  echo "Installing NVM"
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

  echo -e "\n# Node Version Manager" >> ~/.profile
  echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.profile
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.profile
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.profile
  echo -e "\n" >>  ~/.profile
  echo 'autoload -U add-zsh-hook' >> ~/.profile
  echo 'load-nvmrc() {' >> ~/.profile
  echo '  local node_version="$(nvm version)"' >> ~/.profile
  echo '  local nvmrc_path="$(nvm_find_nvmrc)"' >> ~/.profile
  echo -e "\n" >>  ~/.profile
  echo '  if [ -n "$nvmrc_path" ]; then' >> ~/.profile
  echo '    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")' >> ~/.profile
  echo -e "\n" >>  ~/.profile
  echo '    if [ "$nvmrc_node_version" = "N/A" ]; then' >> ~/.profile
  echo '      nvm install' >> ~/.profile
  echo '    elif [ "$nvmrc_node_version" != "$node_version" ]; then' >> ~/.profile
  echo '      nvm use' >> ~/.profile
  echo '    fi' >> ~/.profile
  echo '  elif [ "$node_version" != "$(nvm version default)" ]; then' >> ~/.profile
  echo '    echo "Reverting to nvm default version"' >> ~/.profile
  echo '    nvm use default' >> ~/.profile
  echo '  fi' >> ~/.profile
  echo '}' >> ~/.profile
  echo 'add-zsh-hook chpwd load-nvmrc' >> ~/.profile
  echo -e "load-nvmrc\n" >> ~/.profile

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

###
# Install stable version of Node.js
install_nodejs() {
  echo 'Installing Node.js'
  nvm install stable
  nvm alias default stable
  nvm use default
}

###
# Install and configure PostgreSQL database manager
install_postgres() {
  echo "Installing PostgreSQL"
  sudo apt-get update
  sudo apt-get install -y postgresql postgresql-contrib

  # Set up ubuntu user
  sudo -u postgres bash -c "psql -c \"CREATE USER ubuntu WITH PASSWORD 'ubuntu';\""
  sudo -u postgres bash -c "psql -c \"ALTER USER ubuntu WITH SUPERUSER;\""

  # Make available useful extensions to the schemas
  sudo -u postgres bash -c "psql -c \"CREATE EXTENSION unaccent SCHEMA pg_catalog;\""
  sudo -u postgres bash -c "psql -c \"CREATE EXTENSION pg_trgm SCHEMA pg_catalog;\""

  # Start service
  sudo service postgresql start
}

###
# Install Redis data store
install_redis() {
  echo "Installing Redis"
  sudo apt-get install -y redis-server
}

###
# Install ElasticSearch search engine
install_elasticsearch() {
  echo "Installing Oracle Java 8 and ElasticSearch"
  sudo apt-get install -y openjdk-8-jre apt-transport-https
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
  sudo apt-get update && sudo apt-get install -y elasticsearch

  # This configuration limits ElasticSearch memory use inside the virtual machine
  sudo bash -c "echo 'node.master: true' >> /etc/elasticsearch/elasticsearch.yml"
  sudo sed -i 's/#bootstrap.memory_lock: true/bootstrap.memory_lock: true/g' /etc/elasticsearch/elasticsearch.yml
  sudo sed -i 's/#ES_JAVA_OPTS=/ES_JAVA_OPTS="-Xms256m -Xmx256m"/g' /etc/default/elasticsearch

  sudo /bin/systemctl daemon-reload
  sudo /bin/systemctl enable elasticsearch.service
}

###
# Install Imagemagick image manipulation utilities
install_imagemagick() {
  echo "Installing Imagemagick"
  sudo apt-get install -y imagemagick
}

###
# Install Ngrok secure tunnel manager
install_ngrok() {
  echo 'Installing Ngrok'
  sudo apt-get install -y unzip
  wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
  sudo unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin
  rm -rf ngrok-stable-linux-amd64.zip
}

###
# Fetch basic environment values
fetch_env_files() {
  echo 'Fetching basic environment values'
  curl -sSL https://gist.githubusercontent.com/MakerNetwork/bae611f9f249735ab521f3b0aeea576a/raw/eba0ff7bf005d5164a98937e9b847c92e839e0c1/.envrc > ~/.envrc
  sudo mv ~/.envrc /vagrant/.envrc
  ~/bin/direnv allow /vagrant/.envrc
}

###
# Remove unused software
clean_up() {
  echo "Removing unused software"
  sudo apt-get -y autoremove && sudo apt-get autoclean
}

setup() {
  set_user_config
  system_tunning
  install_nvm
  install_nodejs
  install_rvm
  install_ruby
  install_postgres
  install_redis
  install_elasticsearch
  install_imagemagick
  install_ngrok
  fetch_env_files
  clean_up
}

setup "$@"
