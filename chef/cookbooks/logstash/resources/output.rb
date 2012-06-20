actions :create

attribute :role, :equal_to => ["agent", "web"], :required => true
attribute :config, :kind_of => String
