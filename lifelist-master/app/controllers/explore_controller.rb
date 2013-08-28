class ExploreController < ApplicationController
  before_filter :authenticate_user!, except: :index

  def index
    if user_signed_in?
      @goals = Goal.hierarchs.where(:featured => true).order("id desc").paginate(:per_page => 16, :page => params[:page])
      @goals_listed = current_user.goals_listed
      @goals_done= current_user.goals_done
      if request.xhr?
        sleep(1)
        render partial: 'explore/explore_rows', locals: { goals: @goals }
      end
    else
      @invite_request = InviteRequest.new
      render template: 'devise/sessions/new'
    end
  end


  def topic
    @tag = ActsAsTaggableOn::Tag.where("LOWER(name) = ?", params[:topic].gsub("_and_", " & ")).first
    if @tag.nil?
      redirect_to :action=>"index" 
      return
    end
    @goals = Goal.tagged_with(@tag.name).where(:featured => true).order("id desc").paginate(:per_page => 16, :page => params[:page])
    if request.xhr?
      sleep(1)
      render partial: 'explore/explore_rows', locals: { goals: @goals }
    end
    render :action=>"index"
  end
  
end
