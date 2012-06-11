class Chef
  module ApplicationUser
    module Home
      def application_user_home(user)
        "/home/#{user}"
      end
    end
  end
end
