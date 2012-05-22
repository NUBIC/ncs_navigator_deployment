actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true
attribute :policy, :kind_of => String
attribute :policy_file, :kind_of => String
attribute :version, :kind_of => String, :required => true
