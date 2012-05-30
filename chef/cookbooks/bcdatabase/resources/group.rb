actions :create, :update, :encrypt

attribute :defaults, :kind_of => Hash, :default => {}
attribute :data, :kind_of => Hash, :default => {}
attribute :group, :kind_of => String, :name_attribute => true
