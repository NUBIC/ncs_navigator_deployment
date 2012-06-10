actions :create

attribute :authorized_keys, :respond_to => :to_a, :default => []
attribute :groups, :respond_to => :to_a, :default => []
attribute :shell, :default => nil
attribute :ssh_key_databag, :default => nil
