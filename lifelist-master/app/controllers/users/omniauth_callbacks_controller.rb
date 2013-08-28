class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :check_access

  def facebook
    auth_hash = request.env['omniauth.auth']

    if user_signed_in?
      current_user.add_authorization(auth_hash)
      redirect_to edit_profile_path(current_user)
    else
      authenticate_or_start_registration :facebook, auth_hash
    end
  end

  def twitter
    auth_hash = request.env['omniauth.auth']

    if user_signed_in?
      current_user.add_authorization(auth_hash)
      redirect_to edit_profile_path(current_user)
    else
      authenticate_or_start_registration :twitter, auth_hash
    end
  end

  protected

  def authenticate_or_start_registration provider, auth_hash
    @auth = Authorization.find_from_callback_hash(auth_hash)

    if @auth.present? && @auth.user.present? # authenticate user
      flash[:notice] = "Signed in with #{provider.capitalize}."
      sign_in @auth.user
    else # register user
      token = SignUpToken.find_by_token(session.delete(:sign_up_token))
      redirect_to root_path, alert: "There is no Lifelist account linked with this #{provider.capitalize} account. You can request an invite.".html_safe and return unless token.try(:active?)

      @user = User.new_from_oauth auth_hash, token
      if @user.save
        flash[:notice] = "Registered with #{provider.capitalize}."
        sign_in @user
      else
        flash[:alert] = if @user.errors.include?(:email)
          "A Lifelist user with your #{provider.capitalize} account email already exists. To link your accounts, sign in with your email and view your account settings."
        else
          flash[:alert] = 'Sorry, we could not create your Lifelist account.'
        end
      end
    end
    redirect_to explore_path
  end
end
