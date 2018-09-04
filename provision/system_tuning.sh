#!/usr/bin/env bash

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

system_tuning "$@"
