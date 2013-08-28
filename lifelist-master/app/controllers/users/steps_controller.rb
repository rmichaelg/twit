class Users::StepsController < ApplicationController
  # before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_user, only: [:index]
  respond_to :json

  def index
    @goal = @user.goals.find(params[:goal_id])
    respond_with @goal.steps.as_json(include: :goal)
  end

  def show
    respond_with Step.find(params[:id])
  end

  def create
    @goal = current_user.goals.find(params[:goal_id])
    params[:step][:user_id] = current_user.id
    respond_with @goal.steps.create(params[:step]), location: users_goal_steps_url
  end

  def update
    # raise params.inspect
    @step = current_user.steps.find(params[:id])
    @step.update_attributes(params[:step])
    render json: @step.as_json
  end

  def destroy
    @step = current_user.steps.find(params[:id])
    respond_with @step.destroy
  end

  def sort
    @step = current_user.steps.find(params[:id])
    @step.position = params[:step][:position]
    @step.save!
    respond_with @step
  end
end
