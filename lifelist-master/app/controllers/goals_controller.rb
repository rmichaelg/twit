class GoalsController < ApplicationController
  # before_filter :authenticate_user!, except: [:index, :show]
  before_filter :authenticate_admin_user!, only: [:edit, :crop]
  respond_to :json

  def index
    respond_with Goal.all
  end

  def show
    @user = current_user
    @goal = Goal.find(params[:id])
    respond_to do |format|
      format.json {
        respond_with @goal.as_json(methods: :feature_image_url)
      }
      format.html {
        @goal.copy_to_user(current_user) if params[:listed]
      }
    end
  end

  def create
    respond_with current_user.goals.create(params[:goal]), location: goals_url
  end

  def edit
    @goal = Goal.find(params[:id])
    @goal.build_goal_image unless @goal.image.present?
  end

  def crop
    @goal = Goal.find(params[:id])
    @goal_image = @goal.try(:goal_image)
    if @goal_image.present? && @goal_image.update_attributes(params[:goal][:goal_image_attributes])
      if request.xhr?
        head :no_content
      else
        redirect_to edit_goal_path(@goal), notice: 'Done cropping. Refresh the page.'
      end
    end
  end

  def update
    @goal = current_admin_user.present? ? Goal.find(params[:id]) : current_user.goals.find(params[:id])
    @goal.update_attributes(params[:goal])

    if request.xhr?
      respond_with @goal
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

  def pathways
    @goal = Goal.find(params[:id])
    respond_with @goal.pathways
  end
  
  def add_to_lifelist
    @goal = Goal.find(params[:id])
    respond_with @goal.copy_to_user(current_user)
  end

  def add_to_doneit
    @goal = Goal.find(params[:id])
    respond_with @goal.copy_to_user(current_user, {:copy_steps => false, :status => "Done"})
  end

  def toggle_vote
    @goal = Goal.unscoped.find(params[:id])
    if current_user.voted_on? @goal
      current_user.unvote_for(@goal)
    else
      current_user.vote_for(@goal)
    end

    render json: @goal.as_json(methods: :votes_count)
  end

  def sort
    @goal = current_user.goals.find(params[:id])
    @goal.position = params[:goal][:position]
    @goal.save!
    respond_with @goal
  end
end
