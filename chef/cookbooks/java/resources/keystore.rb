actions :import

%w(keystore storepass).each do |attr|
  attribute attr, :kind_of => String, :required => true
end

attribute :cert_file, :kind_of => String
attribute :cert_alias, :kind_of => String
attribute :user, :kind_of => String, :default => 'root'
