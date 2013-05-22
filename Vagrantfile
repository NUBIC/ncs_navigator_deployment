# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

CODE_SHARE_PATH = ENV['CODE_SHARE_PATH'] || File.dirname(__FILE__) + '/shared/code'

# MiB of memory for each VM
MEM = ENV['MEM'] || 2048

# Virtual CPUs for each VM
CPUS = ENV['CPUS'] || 1

def make_hostname(role)
  username = ENV['USER']
  hostname = `hostname -s`.chomp

  "ncs-#{role}"
end

def ncs_navigator_configuration
  cas_url = "https://ncs-cas.local"
  cases_url = "https://ncs-cases.local"
  ops_url = "https://ncs-ops.local"
  db_host = "#{make_hostname('db')}.local"

  {
    "aker" => {
      "netid" => {},
      "central" => {
        "path" => "/etc/nubic/ncs/aker-local.yml"
      }
    },
    "application_user" => {
      "ssh_key_databag" => "vagrant_public_keys"
    },
    "cas" => {
      "database" => {
        "password" => "CAS#pass"
      }
    },
    "passenger" => {
      "rvm_ruby_string" => "ruby-1.9.3-p429"
    },
    "rvm" => {
      "rubies" => ["ruby-1.9.3-p429"],
      "version" => "1.20.12",
      "upgrade" => "1.20.12"
    },
    "ncs_navigator" => {
      "locations" => [
        { "name" => "Foo",
          "url" => cases_url,
          "machine_account" => {
            "username" => "ncs_navigator_cases_dev",
            "password" => "p@ssw0rd1"
          }
        },
        { "name" => "Bar",
          "url" => cases_url,
          "machine_account" => {
            "username" => "ncs_navigator_cases_dev",
            "password" => "p@ssw0rd1"
          }
        }
      ],
      "cas" => {
        "base_url" => "#{cas_url}/cas",
        "proxy_callback_url" => "#{cas_url}/cas-proxy-callback/receive_pgt",
        "proxy_retrieval_url" => "#{cas_url}/cas-proxy-callback/retrieve_pgt",
        "machine_accounts" => {
          "data" => {
            "users" => {
              "ncs_navigator_cases_dev" => {
                "password" => "p@ssw0rd1"
              }
            }
          }
        }
      },
      "db" => {
        "host" => db_host,
        "admin" => {
          "password" => "p@ssw0rd1"
        }
      },
      "cases" => {
        "study_center" => {
          "sc_id" => "1234567890",
          "recruitment_type_id" => 3,
          "short_name" => "DEV",
          "exception_email_recipients" => [],
          "sampling_units" => {
            "data_bag_item" => "fake_development"
          },
        },
        "machine_account" => {
          "username" => "ncs_navigator_cases_dev",
          "password" => "p@ssw0rd1"
        },
        "app" => {
          "url" => cases_url
        },
        "mail_from" => "ncs-cases@example.edu",
        "db" => {
          "bcdatabase" => {
            "group" => "local_postgresql"
          },
          "user" => {
            "password" => "p@ssw0rd1"
          }
        },
        "redis" => {
          "host" => db_host,
          "bcdatabase" => {
            "group" => "local_redis"
          }
        },
        "user" => {
          "ssh_keys" => [
            "ncs-vagrant"
          ]
        }
      },
      "env" => "development",
      "ops" => {
        "app" => {
          "url" => ops_url
        },
        "db" => {
          "bcdatabase" => {
            "group" => "local_postgresql"
          },
          "user" => {
            "password" => "p@ssw0rd1"
          }
        },
        "user" => {
          "ssh_keys" => [
            "ncs-vagrant"
          ]
        },
        "bootstrap_user" => "abc123",
        "mail_from" => "ncs-ops@example.edu",
        "psc_user_password" => "p@ssw0rd1"
      },
      "psc" => {
        "url" => "https://ncs-psc.local",
        "db" => {
          "user" => {
            "password" => "p@ssw0rd1"
          }
        },
        "user" => {
          "ssh_keys" => [
            "ncs-vagrant"
          ]
        }
      },
      "warehouse" => {
        "db" => {
          "databases" => {
            "mdes_warehouse_working" => {
              "bcdatabase" => {
                "group" => "local_postgresql"
              }
            },
            "mdes_warehouse_reporting" => {
              "bcdatabase" => {
                "group" => "local_postgresql"
              }
            },
            "mdes_import_working" => {
              "bcdatabase" => {
                "group" => "local_postgresql"
              }
            },
            "mdes_import_reporting" => {
              "bcdatabase" => {
                "group" => "local_postgresql"
              }
            }
          },
          "user" => {
            "password" => "p@ssw0rd1"
          }
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

    if ENV['VAGRANT_MODE'] == 'gui'
      config.vm.boot_mode = :gui
    end

    config.vm.customize ['modifyvm', :id, '--memory', MEM]
    config.vm.customize ['modifyvm', :id, '--cpus', CPUS]

    yield config
  end
end

# -----------------------------------------------------------------------------

def provision(config)
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.roles_path = "chef/roles"
    chef.data_bags_path = "chef/data_bags"
    chef.json = {
      "development" => true,
      "zeroconf" => {
        "allowed_interfaces" => ["eth1"]
      }
    }.merge(ncs_navigator_configuration)
    
    yield chef
  end
end

Vagrant::Config.run do |config|
  base_config(:cases, config) do |vmc|
    vmc.vm.network :hostonly, '192.168.56.220'
    vmc.vm.share_folder 'code', '/home/vagrant/code', CODE_SHARE_PATH
    provision(vmc) do |chef|
      chef.run_list = [
        'recipe[zeroconf]',
        'role[ncs_cases]',
        'recipe[ncs_navigator::cases_devenv]'
      ]
    end
  end

  base_config(:ops, config) do |vmc|
    vmc.vm.network :hostonly, '192.168.56.221'
    vmc.vm.share_folder 'code', '/home/vagrant/code', CODE_SHARE_PATH
    provision(vmc) do |chef|
      chef.run_list = [
        'recipe[zeroconf]',
        'recipe[zeroconf::cnames]',
        'role[ncs_ops_psc]',
        'recipe[ncs_navigator::psc_devenv]',
        'recipe[ncs_navigator::ops_devenv]'
      ]

      chef.json['zeroconf'].update({
        'cnames' => ['ncs-psc.local']
      })
    end
  end

  base_config(:cas, config) do |vmc|
    vmc.vm.network :hostonly, '192.168.56.222'
    provision(vmc) do |chef|
      chef.run_list = [
        'recipe[zeroconf]',
        'role[ncs_cas]'
      ]
    end
  end

  base_config(:db, config) do |vmc|
    vmc.vm.network :hostonly, '192.168.56.223'
    provision(vmc) do |chef|
      chef.run_list = [
        'recipe[zeroconf]',
        'role[ncs_webapp_db]'
      ]
    end
  end
end
