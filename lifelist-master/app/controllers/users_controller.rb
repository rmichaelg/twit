class UsersController < ApplicationController
  # before_filter :authenticate_user!, except: [:show]

  def show
    @user = if params[:username]
      if params[:username] == 'profile'
        current_user
      else
        User.find_by_username(params[:username])
      end
    end || not_found
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Profile updated!'
    else
      flash[:errors] = @user.errors.empty? ? "There was a problem updating your profile." : @user.errors.full_messages.to_sentence
    end
    redirect_to edit_profile_path
  end
end
