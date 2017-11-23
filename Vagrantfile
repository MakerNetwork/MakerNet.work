# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.define 'makernetwork-devbox'

  # Port forwarding
  [
    3000, # rails/puma
    9200, # elasticsearch
    5432  # postgres
  ].each do |port|
    config.vm.network "forwarded_port", guest: port, host: port
  end

  # Provider-specific configuration
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--memory', '1536']
  end

  # If you are using Windows o Linux with an encrypted volume
  config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'

  # Provisioning
  config.vm.provision "shell", privileged: false, run: "always",
    path: "provision/zsh_setup.sh"
  config.vm.provision "shell", privileged: false, run: "always",
    path: "provision/box_setup.zsh"
end
