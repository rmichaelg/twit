class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @token = SignUpToken.find_by_token(params[:token])
    # todo: update for new welcome page
    redirect_to root_path and return unless @token.try(:active?)
    session[:sign_up_token] = @token.token

    resource = build_resource({})
    super
  end

  def create
    build_resource

    if resource.save
      @token = SignUpToken.find_by_token(params[:sign_up_token])
      @token.update_attributes(user: resource)

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end
