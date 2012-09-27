CODE_SHARE_PATH = ENV['CODE_SHARE_PATH'] || File.dirname(__FILE__) + '/shared/code'

desc "Clone app repos into the app node's shared folder"
task :clone do
  mkdir_p CODE_SHARE_PATH

  %w(
    ncs_navigator_core
    ncs_staff_portal
  ).each do |repo|
    url = "git@github.com:NUBIC/#{repo}.git"

    target = "#{CODE_SHARE_PATH}/#{repo}"

    sh "git clone #{url} #{target}"
  end
end
