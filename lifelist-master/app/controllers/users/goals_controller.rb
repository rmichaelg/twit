class Users::GoalsController < ApplicationController
  # before_filter :authenticate_user!, except: [:index, :show]
  before_filter :authenticate_admin_user!, only: [:edit, :crop]
  before_filter :find_user, only: [:index, :show]
  respond_to :json

  def index
    respond_to do |format|
      format.html { redirect_to UsersController.helpers.profile_path(@user) }
      format.json { respond_with @user.goals.as_json(methods: :feature_image_url) }
    end
  end

  def show
    respond_to do |format|
      format.html { render template: 'users/show' }
      format.json { respond_with @user.goals.find(params[:id]).as_json(methods: :feature_image_url) }
    end
  end

  def create
    respond_with current_user.goals.create(params[:goal]), location: goals_url
  end

  def edit
    @goal = Goal.find(params[:id])
    @goal.build_goal_image unless @goal.image.present?
  end

  def update
    @goal = current_admin_user.present? ? Goal.find(params[:id]) : current_user.goals.find(params[:id])

    if params.has_key? :publish
      params[:publish] ? @goal.publish! : @goal.unpublish!
    end
    @goal.update_attributes(params[:goal])

    if request.xhr?
      render json: @goal.as_json(methods: :feature_image_url)
    else
      redirect_to edit_goal_path(@goal), notice: 'Goal updated.'
    end
  end

  def destroy
    @goal = current_user.goals.find(params[:id])
    respond_with @goal.destroy
  end

  def autoassign_image
    goal = Goal.find(params[:id])
    goal.autoassign_image if goal.remote_image_url.blank?
    respond_with goal
  end

  def featured
    @goals = Goal.where(:featured => true).order("id desc").all
    respond_with @goals
  end

  def sort
    @goal = current_user.goals.find(params[:id])
    @goal.position = params[:goal][:position]
    @goal.save!
    respond_with @goal
  end
end
