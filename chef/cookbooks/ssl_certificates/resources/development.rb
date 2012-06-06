actions :install, :uninstall

attribute :path, :name_attribute => true
attribute :basename, :kind_of => String, :required => true
attribute :owner, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true
