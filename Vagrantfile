# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

def make_hostname(role)
  username = ENV['USER']
  hostname = `hostname -s`.chomp

  "ncs-#{role}-#{username}-#{hostname}"
end

def ncs_navigator_configuration
  cas = "#{make_hostname("cas")}.local"
  db = "#{make_hostname("db")}.local"

  {
    "aker" => {
      "netid" => {}
    },
    "ncs_navigator" => {
      "cas" => {
        "base_url" => "https://#{cas}/cas",
        "proxy_callback_url" => "https://#{cas}/cas-proxy-callback/receive_pgt",
        "proxy_retrieval_url" => "https://#{cas}/cas-proxy-callback/retrieve_pgt"
      },
      "core" => {
        "database" => {
          "host" => db,
          "password" => "p@ssw0rd1"
        },
        "redis" => {
          "host" => db,
          "port" => 6379
        },
        "ssh_keys" => ["ncs-vagrant"]
      },
      "psc" => {
        "database" => {
          "host" => db,
          "password" => "p@ssw0rd1"
        }
      },
      "staff_portal" => {
        "database" => {
          "host" => db,
          "password" => "p@ssword1"
        },
        "ssh_keys" => ["ncs-vagrant"]
      },
      "study_center" => {
        "sampling_units" => {
          "data_bag_item" => "fake_development",
          "target" => "/etc/nubic/ncs/ssu_tsu.csv"
        }
      }
    },
    "postgresql" => {
      "hba" => [
        { "type" => "host",
          "database" => "all",
          "user" => "all",
          "cidr-address" => "192.168.56.0/24",
          "ident" => "md5"
        }
      ]
    }
  }
end

def base_config(role, config)
  config.vm.define role do |config|
    config.vm.box = "ncs"
    config.vm.host_name = make_hostname(role)

    config.ssh.private_key_path = "ncs-vagrant"

    config.vm.provision :chef_client do |chef|
      chef.chef_server_url = CHEF_SERVER_URL
      chef.environment = "development"
      chef.validation_key_path = "nubic-validator.pem"
      chef.run_list = ["role[ncs_#{role}]"]
      chef.json = {
        "zeroconf" => {
          "allowed_interfaces" => ["eth1"]
        }
      }.merge(ncs_navigator_configuration)
    end

    yield config
  end
end

# -----------------------------------------------------------------------------

# The Chef server to use.
CHEF_SERVER_URL = "http://chef-server.nubic.northwestern.edu:4000"

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
