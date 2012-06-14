default["logstash"]["agent"]["conf"] = "/etc/logstash/agent.conf"
default["logstash"]["agent"]["bin_dir"] = "/usr/local/bin"
default["logstash"]["agent"]["home_dir"] = "/var/logstash"
default["logstash"]["agent"]["pid_file"] = "/var/run/logstash.pid"

default["logstash"]["agent"]["source"]["file"] = "http://semicomplete.com/files/logstash/logstash-1.1.0.1-monolithic.jar"
default["logstash"]["agent"]["source"]["checksum"] = "9808bd88725f3166c26d21b96226da3e36dad089cea91f6e22a645365724e4d9"
default["logstash"]["agent"]["user"] = "logstash"
default["logstash"]["agent"]["group"] = "logstash"
default["logstash"]["agent"]["shell"] = "/sbin/nologin"
default["logstash"]["agent"]["init"] = "/etc/init.d/logstash"
default["logstash"]["agent"]["input"] = []
default["logstash"]["agent"]["output"] = []
