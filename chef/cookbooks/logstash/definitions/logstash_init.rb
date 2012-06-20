define :logstash_init do
  extend Chef::Logstash::Paths

  role = params[:role]
  pidfile = logstash_pid_path(role)
  init = logstash_init_path(role)
  config = logstash_conf_path(role)
  binary = logstash_binary_path

  template init do
    source "logstash_init.sh.erb"
    mode 0755
    variables :pidfile => pidfile,
              :config => config,
              :user => node["logstash"]["user"],
              :bin => binary,
              :role => role
  end
end
