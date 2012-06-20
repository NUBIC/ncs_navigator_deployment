require 'uri'

class Chef
  module Logstash
    module Paths
      def logstash_binary_path
        source = node["logstash"]["source"]["file"]
        filename = URI(source).path.split('/').last

        "#{node["logstash"]["bin_dir"]}/#{filename}"
      end

      def logstash_conf_path(role)
        "#{node["logstash"]["conf_base"]}/logstash.#{role}.conf"
      end

      def logstash_pid_path(role)
        "#{node["logstash"]["pid_file_base"]}/#{logstash_service(role)}"
      end

      def logstash_init_path(role)
        "#{node["logstash"]["init_base"]}/#{logstash_service(role)}"
      end

      def logstash_service(role)
        "logstash-#{role}"
      end
    end
  end
end
