module UsersHelper
  def profile_path user=nil
    if user.try(:username).present?
      "/#{user.username}"
    else
      "/profile"
    end
  end

  def profile_url user=nil
    host = Rails.configuration.action_mailer.default_url_options[:host]
    "http://#{host}#{profile_path(user)}"
  end
end
