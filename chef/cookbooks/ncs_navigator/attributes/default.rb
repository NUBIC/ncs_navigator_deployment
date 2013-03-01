cases_app_root = "/var/www/apps/ncs_navigator_core"
cases_current = "#{cases_app_root}/current"
cases_shared = "#{cases_app_root}/shared"
ops_app_root = "/var/www/apps/ncs_staff_portal"
ops_current = "#{ops_app_root}/current"
ops_shared = "#{ops_app_root}/shared"

default["ncs_navigator"]["cas"]["machine_accounts"]["file"] = "/etc/nubic/ncs/machine_accounts.yml"
default["ncs_navigator"]["cases"]["app"]["current_path"] = cases_current
default["ncs_navigator"]["cases"]["app"]["min_instances"] = "5"
default["ncs_navigator"]["cases"]["app"]["root"] = cases_app_root
default["ncs_navigator"]["cases"]["app"]["shared_path"] = cases_shared
default["ncs_navigator"]["cases"]["db"]["bcdatabase"]["config"] = "ncs_navigator_core"
default["ncs_navigator"]["cases"]["db"]["name_prefix"] = "ncs_navigator_cases"
default["ncs_navigator"]["cases"]["db"]["password_path"] = "/etc/nubic/.chef-state/cases_password"
default["ncs_navigator"]["cases"]["db"]["pool_size"] = "10"
default["ncs_navigator"]["cases"]["db"]["user_prefix"] = "ncs_navigator_cases"
default["ncs_navigator"]["cases"]["old_log_path"] = "#{cases_shared}/old_logs"
default["ncs_navigator"]["cases"]["redis"]["bcdatabase"]["config"] = "ncs_navigator_cases"
default["ncs_navigator"]["cases"]["redis"]["db"] = 0
default["ncs_navigator"]["cases"]["redis"]["host"] = "localhost"
default["ncs_navigator"]["cases"]["redis"]["port"] = "6379"
default["ncs_navigator"]["cases"]["scheduler"]["log"] = "#{cases_shared}/log/scheduler.log"
default["ncs_navigator"]["cases"]["scheduler"]["pid"] = "#{cases_shared}/pids/scheduler.pid"
default["ncs_navigator"]["cases"]["session_secret"]["env_var"] = "CORE_SECRET"
default["ncs_navigator"]["cases"]["session_secret"]["path"] = "/etc/nubic/.chef-state/cases_session_secret"
default["ncs_navigator"]["cases"]["ssl"]["certificate"] = "/etc/pki/tls/certs/cases.crt"
default["ncs_navigator"]["cases"]["ssl"]["key"] = "/etc/pki/tls/private/cases.key"
default["ncs_navigator"]["cases"]["study_center"]["exception_email_recipients"] = []
default["ncs_navigator"]["cases"]["study_center"]["footer_logo_left"]["checksum"] = "2d288345f95e90c25a59068b6eab776c82ff6c555a80d41322ba203bccc9d524"
default["ncs_navigator"]["cases"]["study_center"]["footer_logo_left"]["path"] = "/var/www/apps/ncs_shared/footer_logo_left.png"
default["ncs_navigator"]["cases"]["study_center"]["footer_logo_left"]["source"] = "https://github.com/NUBIC/ncs_navigator_deployment/raw/51d699dd797fc0deb3371af25f5c49b9dce6a38b/logos/footer_left.png"
default["ncs_navigator"]["cases"]["study_center"]["footer_logo_right"]["checksum"] = "7583e308a380440b4cd47c0fcb7599113d81e499ccb78f50e303eaf34e8c5d2f"
default["ncs_navigator"]["cases"]["study_center"]["footer_logo_right"]["path"] = "/var/www/apps/ncs_shared/footer_logo_right.png"
default["ncs_navigator"]["cases"]["study_center"]["footer_logo_right"]["source"] = "https://github.com/NUBIC/ncs_navigator_deployment/raw/51d699dd797fc0deb3371af25f5c49b9dce6a38b/logos/footer_right.png"
default["ncs_navigator"]["cases"]["study_center"]["sampling_units"]["data_bag"] = "ncs_ssus"
default["ncs_navigator"]["cases"]["study_center"]["sampling_units"]["target"] = "/etc/nubic/ncs/ssu_tsus.csv"
default["ncs_navigator"]["cases"]["study_center"]["username"] = "NetID"
default["ncs_navigator"]["cases"]["sync_log_level"] = "DEBUG"
default["ncs_navigator"]["cases"]["user"]["groups"] = []
default["ncs_navigator"]["cases"]["user"]["name"] = "ncs_navigator_cases"
default["ncs_navigator"]["cases"]["user"]["ssh_keys"] = []
default["ncs_navigator"]["cases"]["with_specimens"] = "false"
default["ncs_navigator"]["cases"]["worker"]["concurrency"] = "5"
default["ncs_navigator"]["cases"]["worker"]["log"] = "#{cases_shared}/log/sidekiq.log"
default["ncs_navigator"]["cases"]["worker"]["pid"] = "#{cases_shared}/pids/sidekiq.pid"
default["ncs_navigator"]["db"]["admin"]["user"] = "ncs_navigator_db_admin"
default["ncs_navigator"]["db"]["port"] = "5432"
default["ncs_navigator"]["hosted_data"]["dir"] = "/var/www/apps/ncs_navigator_hosted_data"
default["ncs_navigator"]["ini"]["path"] = "/etc/nubic/ncs/navigator.ini"
default["ncs_navigator"]["instruments"]["dir"] = "/var/www/apps/ncs_instruments"
default["ncs_navigator"]["ops"]["app"]["current_path"] = ops_current
default["ncs_navigator"]["ops"]["app"]["min_instances"] = "5"
default["ncs_navigator"]["ops"]["app"]["root"] = ops_app_root
default["ncs_navigator"]["ops"]["app"]["shared_path"] = ops_shared
default["ncs_navigator"]["ops"]["db"]["bcdatabase"]["config"] = "ncs_staff_portal"
default["ncs_navigator"]["ops"]["db"]["name"] = "ncs_navigator_ops"
default["ncs_navigator"]["ops"]["db"]["pool_size"] = "5"
default["ncs_navigator"]["ops"]["db"]["user"]["name"] = "ncs_navigator_ops"
default["ncs_navigator"]["ops"]["email_reminder"] = "false"
default["ncs_navigator"]["ops"]["exception_recipients"] = []
default["ncs_navigator"]["ops"]["old_log_path"] = "#{ops_shared}/old_logs"
default["ncs_navigator"]["ops"]["session_secret"]["env_var"] = "STAFF_PORTAL_SECRET"
default["ncs_navigator"]["ops"]["session_secret"]["path"] = "/etc/nubic/.chef-state/ops_session_secret"
default["ncs_navigator"]["ops"]["ssl"]["certificate"] = "/etc/pki/tls/certs/ops.crt"
default["ncs_navigator"]["ops"]["ssl"]["key"] = "/etc/pki/tls/private/ops.key"
default["ncs_navigator"]["ops"]["status_endpoint"] = "/"
default["ncs_navigator"]["ops"]["user"]["groups"] = []
default["ncs_navigator"]["ops"]["user"]["name"] = "ncs_navigator_ops"
default["ncs_navigator"]["ops"]["user"]["ssh_keys"] = []
default["ncs_navigator"]["psc"]["db"]["bcdatabase"]["config"] = "psc"
default["ncs_navigator"]["psc"]["db"]["bcdatabase"]["group"] = "ncsdb_prod"
default["ncs_navigator"]["psc"]["db"]["config_file"] = "/etc/psc/datasource.properties"
default["ncs_navigator"]["psc"]["db"]["name"] = "psc"
default["ncs_navigator"]["psc"]["db"]["user"]["name"] = "psc"
default["ncs_navigator"]["psc"]["ssl"]["ca_file"] = "/etc/pki/tls/certs/psc_ca.crt"
default["ncs_navigator"]["psc"]["ssl"]["certificate"] = "/etc/pki/tls/certs/psc.crt"
default["ncs_navigator"]["psc"]["ssl"]["key"] = "/etc/pki/tls/private/psc.key"
default["ncs_navigator"]["psc"]["status_endpoint"] = "/api/v1/system-status"
default["ncs_navigator"]["psc"]["tomcat"]["max_heap_size"] = "1024M"
default["ncs_navigator"]["psc"]["tomcat"]["max_perm_size"] = "512M"
default["ncs_navigator"]["psc"]["user"]["groups"] = []
default["ncs_navigator"]["psc"]["user"]["name"] = "psc_deployer"
default["ncs_navigator"]["psc"]["user"]["ssh_keys"] = []
default["ncs_navigator"]["smtp"]["host"] = "localhost"
default["ncs_navigator"]["smtp"]["port"] = "25"
default["ncs_navigator"]["smtp"]["starttls"] = "false"
default["ncs_navigator"]["warehouse"]["config"]["dir"] = "/etc/nubic/ncs/warehouse"
default["ncs_navigator"]["warehouse"]["db"]["password_path"] = "/etc/nubic/.chef-state/warehouse_password"
default["ncs_navigator"]["warehouse"]["db"]["user_prefix"] = "ncs_mdes_warehouse"
default["ncs_navigator"]["warehouse"]["log"]["dir"] = "/var/log/nubic/ncs/warehouse"
default["ncs_navigator"]["warehouse"]["user"]["groups"] = []
default["ncs_navigator"]["warehouse"]["user"]["name"] = "ncs_mdes_warehouse"
default["ncs_navigator"]["warehouse"]["user"]["ssh_keys"] = []

%w(
  mdes_warehouse_working
  mdes_warehouse_reporting
  mdes_import_working
  mdes_import_reporting
).each do |db|
  default["ncs_navigator"]["warehouse"]["db"]["databases"][db]["name_prefix"] = db
  default["ncs_navigator"]["warehouse"]["db"]["databases"][db]["bcdatabase"]["config"] = db
end
