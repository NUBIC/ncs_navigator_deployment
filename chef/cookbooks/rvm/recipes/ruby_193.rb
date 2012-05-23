#
# Cookbook Name:: rvm
# Recipe:: ruby_193

# Install deps as listed by recent revisions of RVM.
packages = case node[:platform]
           when 'debian','ubuntu'
            %w(build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool bison subversion)
           when 'centos','redhat','fedora','scientific'
            %w(gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi openssl-devel make bzip2 autoconf automake libtool bison)
           end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

node.default[:rvm][:ruby][:implementation] = 'ruby'
node.default[:rvm][:ruby][:version] = '1.9.3'
include_recipe "rvm::install"
