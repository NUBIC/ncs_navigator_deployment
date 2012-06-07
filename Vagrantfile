# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

def make_hostname(role)
  username = ENV['USER']
  hostname = `hostname -s`.chomp

  "ncs-#{role}-#{username}-#{hostname}"
end

def base_config(role, config)
  config.vm.define role do |config|
    config.vm.box = "ncs"
    config.vm.host_name = make_hostname(role)

    config.ssh.private_key_path = "ncs-vagrant"

    config.vm.provision :chef_client do |chef|
      chef.chef_server_url = CHEF_SERVER_URL
      chef.environment = "ncs_development"
      chef.validation_key_path = "nubic-validator.pem"
      chef.run_list = ["role[ncs_#{role}]"]

      cas_mdns_name = "#{HOSTNAMES['cas']}.local"

      chef.json = {
        "app_urls" => APP_URLS,
        "cas" => {
          "base_url" => "https://#{cas_mdns_name}/cas",
          "proxy_retrieval_url" => "https://#{cas_mdns_name}/cas-proxy-callback/retrieve_pgt",
          "proxy_callback_url" => "https://#{cas_mdns_name}/cas-proxy-callback/receive_pgt"
        }
      }
    end

    yield config
  end
end

# -----------------------------------------------------------------------------

# The Chef server to use.
CHEF_SERVER_URL = "http://chef-server.nubic.northwestern.edu:4000"

# Hostnames.
HOSTNAMES = Hash[*(%w(app cas db).map { |n| [n, make_hostname(n)] }.flatten)]

# URLs of applications.
APP_URLS = {
  "ncs_navigator" => {
    "core" => "https://navigator.#{HOSTNAMES['app']}.local",
    "staffportal" => "https://staffportal.#{HOSTNAMES['app']}.local",
    "psc" => "https://navcal.#{HOSTNAMES['app']}.local"
  }
}

Vagrant::Config.run do |config|
  base_config(:app, config) do |app_config|
    app_config.vm.network :hostonly, '192.168.56.220'
  end

  base_config(:cas, config) do |cas_config|
    cas_config.vm.network :hostonly, '192.168.56.222'
  end

  base_config(:db, config) do |db_config|
    db_config.vm.network :hostonly, '192.168.56.221'
  end
end
