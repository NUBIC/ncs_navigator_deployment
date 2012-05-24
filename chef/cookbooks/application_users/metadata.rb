maintainer       "NUBIC"
maintainer_email "yipdw@northwestern.edu"
license          "Apache 2.0"
description      "Sets up application users on application servers"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0"

depends          "selinux"

recipe "default", "Sets up application users"

attribute "application_users/groups",
  :display_name => "Group for users",
  :description => "Group for application users",
  :type => "string",
  :default => "app",
  :recipes => ["default"]

attribute "application_users/shell",
  :display_name => "Shell",
  :description => "Shell for application users",
  :type => "string",
  :default => "/bin/sh",
  :recipes => ["default"]

attribute "application_users/ssh_key_databag",
  :display_name => "SSH key databag",
  :description => "Name of the databag to use for SSH public keys",
  :type => "string",
  :default => "ssh_public_keys",
  :recipes => ["default"]

attribute "application_users/users",
  :display_name => "Users",
  :description => "Mapping of username -> user data",
  :type => "hash",
  :default => {},
  :recipes => ["default"]
