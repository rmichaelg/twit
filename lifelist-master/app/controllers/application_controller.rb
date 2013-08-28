class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def find_user
    @user = if params[:username] == 'profile'
      current_user
    else
      User.find_by_username(params[:username])
    end || not_found
  end
end
