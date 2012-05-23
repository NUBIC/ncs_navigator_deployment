# -*- mode: ruby -*-
# vi: set ft=ruby :

RUN_LISTS = {
  :app => [
    'role[ncs_app]'
  ],
  :cas => [
    'role[ncs_common]',
  ],
  :db => [
    'role[ncs_db]'
  ]
}

def base_config(role, config)
  username = ENV['USER']
  hostname = `hostname -s`.chomp

  raise "No run list defined for #{role}" if RUN_LISTS[role].nil?

  config.vm.define role do |config|
    config.vm.box = "ncs"
    config.vm.host_name = "ncs-#{role}-#{username}-#{hostname}"
    
    config.ssh.private_key_path = "ncs-vagrant"

    config.vm.provision :chef_client do |chef|
      chef.chef_server_url = "http://192.168.56.1:4000"
      chef.environment = "ncs_development"
      chef.validation_key_path = "nubic-validator.pem"
      chef.run_list = RUN_LISTS[role]
    end

    yield config
  end
end

Vagrant::Config.run do |config|
  base_config(:app, config) do |app_config|
    app_config.vm.network :hostonly, "192.168.56.220"
  end

  base_config(:cas, config) do |cas_config|
    cas_config.vm.network :hostonly, "192.168.56.222"
  end

  base_config(:db, config) do |db_config|
    db_config.vm.network :hostonly, "192.168.56.221"
  end
end
