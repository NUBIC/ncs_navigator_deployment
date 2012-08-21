# The user configuration needs at least `node_name` and `client_key` set.
user_configuration = File.expand_path('~/.chef/knife.rb')
if File.exist?(user_configuration)
  eval(File.read user_configuration)
end

cookbook_path File.expand_path('../chef/cookbooks', __FILE__)

chef_server_url 'http://chef-server.nubic.northwestern.edu:4000'
file_cache_path File.expand_path('~/.chef/repo-cache')
cache_options :path => File.expand_path('~/.chef/checksums')
