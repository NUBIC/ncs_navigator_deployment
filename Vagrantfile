# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

RUN_LISTS = {
  :app => [
    'role[ncs_app]'
  ],
  :cas => [
    'recipe[zeroconf]',
    'role[ncs_cas]',
  ],
  :db => [
    'role[ncs_db]'
  ]
}

IPS = {
  :app => '192.168.56.220',
  :cas => '192.168.56.222',
  :db => '192.168.56.221',
  :chef => '192.168.56.1'
}

fn = File.expand_path('../.local_vagrant.yml', __FILE__)
CUSTOMIZATIONS = File.exists?(fn) ? YAML.load(File.read(fn)) : {}

def make_hostname(role)
  username = ENV['USER']
  hostname = `hostname -s`.chomp

  "ncs-#{role}-#{username}-#{hostname}"
end

def base_config(role, config)
  raise "No run list defined for #{role}" if RUN_LISTS[role].nil?

  config.vm.define role do |config|
    config.vm.box = "ncs"
    config.vm.host_name = make_hostname(role)
    
    config.ssh.private_key_path = "ncs-vagrant"

    config.vm.provision :chef_client do |chef|
      chef.chef_server_url = "http://#{IPS[:chef]}:4000"
      chef.environment = "ncs_development"
      chef.validation_key_path = "nubic-validator.pem"
      chef.run_list = RUN_LISTS[role]

      cas_mdns_name = "#{make_hostname('cas')}.local"

      chef.json = {
        "cas" => {
          "base_url" => "https://#{cas_mdns_name}/cas",
          "proxy_retrieval_url" => "https://#{cas_mdns_name}/cas-proxy-callback/retrieve_pgt",
          "proxy_callback_url" => "https://#{cas_mdns_name}/cas-proxy-callback/receive_pgt",
          "apache" => {
            "ssl_certificate" => "/etc/httpd/ssl/cas.crt",
            "ssl_certificate_key" => "/etc/httpd/ssl/cas.key"
          }
        },
        "pers" => {
          "bcdatabase" => {}
        }
      }.merge(CUSTOMIZATIONS[role.to_s] || {})
    end

    yield config
  end
end

Vagrant::Config.run do |config|
  base_config(:app, config) do |app_config|
    app_config.vm.network :hostonly, IPS[:app]
  end

  base_config(:cas, config) do |cas_config|
    cas_config.vm.network :hostonly, IPS[:cas]
  end

  base_config(:db, config) do |db_config|
    db_config.vm.network :hostonly, IPS[:db]
  end
end
