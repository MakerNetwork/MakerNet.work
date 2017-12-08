#!/usr/bin/env zsh

# Install Node Version Manager ################################################

echo "***************************************************"
echo "Checking for NVM... "
echo "***************************************************"
if [[ ! -x "$HOME/.nvm" ]]; then
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

  echo '# Node Version Manager'  >> ~/.profile
  echo 'export NVM_DIR="$HOME/.nvm"'  >> ~/.profile
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'  >> ~/.profile
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'  >> ~/.profile

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
else
  echo "OK"
fi


# Install Node.js #############################################################

echo "***************************************************"
echo "Checking for Node.js... "
echo "***************************************************"
if ! node --version; then
  nvm install 6.11
  nvm use 6.11
else
  echo 'OK'
fi


# Ruby and Version Manager ####################################################

echo "***************************************************"
echo 'Cheking for Ruby... '
echo "***************************************************"
if ! ruby -v; then
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  sudo apt-get install -y libxml2 libxml2-dev libxslt1-dev libpq-dev
  \curl -sSL https://get.rvm.io | bash
  source /home/ubuntu/.rvm/scripts/rvm
  rvm get head
  rvm install ruby-2.3.5
  rvm use ruby-2.3.5@global
  gem update --system --no-ri --no-rdoc
  gem update --no-ri --no-rdoc
  rvm use ruby-2.3.5 --default
  sudo apt-get autoremove
else
  echo 'OK'
fi


# Install and setup PostgreSQL ################################################

echo "***************************************************"
echo "Checking Postgres installation..."
echo "***************************************************"
if ! dpkg -s postgresql; then
  echo "Installing PostgreSQL"
  sudo apt-get update
  sudo apt-get install -y postgresql postgresql-contrib

  echo "Setting up user"
  sudo -u postgres bash -c "psql -c \"CREATE USER ubuntu WITH PASSWORD 'ubuntu';\""
  sudo -u postgres bash -c "psql -c \"ALTER USER ubuntu WITH SUPERUSER;\""

  echo "Setting up extensions to all schemas"
  sudo -u postgres bash -c "psql -c \"CREATE EXTENSION unaccent SCHEMA pg_catalog;\""
  sudo -u postgres bash -c "psql -c \"CREATE EXTENSION pg_trgm SCHEMA pg_catalog;\""
fi

echo "***************************************************"
echo "             Starting Postgres server              "
echo "***************************************************"
sudo service postgresql start


# Install Redis ###############################################################

echo "***************************************************"
echo "Checking Redis installation..."
echo "***************************************************"
if ! dpkg -s redis-server; then
  echo "Instalating Redis"
  sudo apt-get install -y redis-server
fi


# Install Imagemagick #########################################################

echo "***************************************************"
echo "Checking Imagemagik installation..."
echo "***************************************************"
if ! dpkg -s imagemagick; then
  sudo apt-get install -y imagemagick
else
  echo 'OK'
fi


# Install ElasticSearch #######################################################

echo "***************************************************"
echo "Checking ElasticSearch installation..."
echo "***************************************************"
if ! dpkg -s elasticsearch; then
  sudo apt-get install -y openjdk-8-jre apt-transport-https
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
  echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
  sudo apt-get update && sudo apt-get install -y elasticsearch

  sudo echo "node.master: true" >> /etc/elasticsearch/elasticsearch.yml
  sudo echo "node.data: false" >> /etc/elasticsearch/elasticsearch.yml
  sudo sed -i 's/#bootstrap.memory_lock: true/bootstrap.memory_lock: true/g' /etc/elasticsearch/elasticsearch.yml
  sudo sed -i 's/#ES_JAVA_OPTS=/ES_JAVA_OPTS="-Xms256m -Xmx256m"/g' /etc/default/elasticsearch

  sudo /bin/systemctl daemon-reload
  sudo /bin/systemctl enable elasticsearch.service
else
  echo 'OK'
fi


# Install Yarn package manager ################################################

echo "***************************************************"
echo "Checking Yarn installation..."
echo "***************************************************"
if ! dpkg -s yarn; then
 curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
 echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
 sudo apt-get update && sudo apt-get install -y yarn
fi


# Install Direnv switcher ####################################################

echo "***************************************************"
echo "Checking for Direnv... "
echo "***************************************************"
if ! direnv; then
  wget https://bin.equinox.io/c/4Jbv9XAvTAU/direnv-stable-linux-amd64.tgz
  sudo tar xvf direnv-stable-linux-amd64.tgz -C /usr/local/bin
  rm -rf direnv-stable-linux-amd64.tgz

  echo '\n'
  echo '# Hook direnv' >> ~/.zshrc
  echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
else
  echo 'OK'
fi
