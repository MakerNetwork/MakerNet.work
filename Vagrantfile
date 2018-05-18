# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
# Use the standard version or the dockerized version
USE_DOCKER_VERSION = false

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Provider-specific configuration
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--memory', '4096']
  end

  # If you are using Windows o Linux with an encrypted volume
  config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'

  if USE_DOCKER_VERSION
    config.vm.box = 'ubuntu/xenial64'
    config.vm.define 'makernetwork-docker'

    # Port forwarding
    config.vm.network "forwarded_port", guest: 80, host: 3000

    config.vm.provision "shell", privileged: true, run: "once",
      path: "provision/system_tuning.sh"

    config.vm.provision "shell", privileged: false, run: "once",
      path: "provision/docker_setup.sh",
      env: {
        "LC_ALL"   => "en_US.UTF-8",
        "LANG"     => "en_US.UTF-8",
        "LANGUAGE" => "en_US.UTF-8",
      }
  else
    config.vm.box = 'ubuntu/bionic64'
    config.vm.define 'makernetwork-devbox'

    # Port forwarding
    [
      3000, # rails/puma
      9200, # elasticsearch
      5432, # postgres
      1080, # mailcatcher web ui
      4040  # ngrok web ui
    ].each do |port|
      config.vm.network "forwarded_port", guest: port, host: port
    end

    ## Provisioning
    config.vm.provision "shell", privileged: false, run: "once",
      path: "provision/zsh_setup.sh"

    config.vm.provision "shell", privileged: false, run: "once",
      path: "provision/box_setup.zsh",
      env: {
        "LC_ALL"   => "en_US.UTF-8",
        "LANG"     => "en_US.UTF-8",
        "LANGUAGE" => "en_US.UTF-8",
      }
  end

end
