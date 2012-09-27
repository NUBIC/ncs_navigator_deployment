# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

CODE_SHARE_PATH = ENV['CODE_SHARE_PATH'] || File.dirname(__FILE__) + '/shared/code'

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
    "application_user" => {
      "ssh_key_databag" => "vagrant_public_keys"
    },
    "cas" => {
      "database" => {
        "password" => "CAS#pass"
      }
    },
    "ncs_navigator" => {
      "machine_accounts" => {
        "data" => {
          "users" => {
            "cases_merge" => {
              "password" => "cases_merge"
            }
          }
        }
      },
      "diagnostic_users" => [
        "vagrant"
      ],
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
    },
    "tomcat" => {
      "keystore" => {
        "password" => 'keypass'
      }
    }
  }
end

def base_config(role, config)
  config.vm.define role do |config|
    config.vm.box = "ncs"
    config.vm.host_name = make_hostname(role)

    config.ssh.private_key_path = "ncs-vagrant"

    config.vm.provision :chef_solo do |chef|
      chef.run_list = ["recipe[zeroconf]", "role[ncs_#{role}]"]
      chef.cookbooks_path = "chef/cookbooks"
      chef.roles_path = "chef/roles"
      chef.data_bags_path = "chef/data_bags"
      chef.json = {
        "development" => true,
        "zeroconf" => {
          "allowed_interfaces" => ["eth1"]
        }
      }.merge(ncs_navigator_configuration)
    end

    if ENV['VAGRANT_MODE'] == 'gui'
      config.vm.boot_mode = :gui
    end

    config.vm.customize ['modifyvm', :id, '--memory', ENV['MEM']] if ENV['MEM']
    config.vm.customize ['modifyvm', :id, '--cpus', ENV['CPUS']] if ENV['CPUS']

    yield config
  end
end

# -----------------------------------------------------------------------------

Vagrant::Config.run do |config|
  base_config(:app, config) do |app_config|
    app_config.vm.network :hostonly, '192.168.56.220'

    app_config.vm.share_folder 'code', '/home/vagrant/code', CODE_SHARE_PATH
  end

  base_config(:cas, config) do |cas_config|
    cas_config.vm.network :hostonly, '192.168.56.222'
  end

  base_config(:db, config) do |db_config|
    db_config.vm.network :hostonly, '192.168.56.221'
  end
end
