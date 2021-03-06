package "monit" do
  action :upgrade
  version "5.5-1"
end

monit_conf = case node[:platform]
             when "ubuntu","debian"
               "/etc/monit/monitrc"
             when "centos"
               "/etc/monit.conf"
             end

if platform?("ubuntu")
  cookbook_file "/etc/default/monit" do
    source "monit.default"
    owner "root"
    group "root"
    mode 0644
  end
end

service "monit" do
  action :nothing
  enabled true
  supports [:start, :restart, :stop]
end

template monit_conf do
  owner "root"
  group "root"
  mode 0700
  source 'monitrc.erb'
  notifies :restart, resources(:service => "monit")
end

directory "/etc/monit/conf.d/" do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

iptables_rule "monit_httpd_in", :cookbook => "monit"

service "monit" do
  action :enable
end
