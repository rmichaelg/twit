class Users::SessionsController < Devise::SessionsController
  def new
    @invite_request = InviteRequest.new
    super
  end
end
