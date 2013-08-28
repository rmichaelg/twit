class InviteRequestsController < ApplicationController
  skip_before_filter :authenticate_user!
  respond_to :json

  def create
    @invite_request = InviteRequest.create(params[:invite_request])
    @invite_request.save
    InviteRequestMailer.invite_requested(@invite_request).deliver
    respond_with @invite_request
  end
end
