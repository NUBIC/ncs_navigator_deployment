default[:logstash][:basedir] = "/opt/logstash"
default[:logstash][:user] = "logstash"
default[:logstash][:group] = "logstash"

# roles/flags for various search/discovery
default[:logstash][:graphite_role] = "graphite_server"
default[:logstash][:elasticsearch_role] = "elasticsearch_server"
default[:logstash][:elasticsearch_cluster] = "logstash"
