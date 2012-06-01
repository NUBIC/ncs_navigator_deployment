actions :create_if_missing, :update, :encrypt

attribute :data, :kind_of => Hash, :default => {}
attribute :group, :kind_of => String, :name_attribute => true
