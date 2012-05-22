action :restore do
  execute "restore security context" do
    command "restorecon -r -F #{new_resource.path}"
  end
end
