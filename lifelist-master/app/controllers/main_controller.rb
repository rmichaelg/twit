class MainController < ApplicationController
  before_filter :authenticate_user!

  def index
    @categories = Category.order(:name).all.to_json
  end
  
  def explore
    @categories = Category.order(:name).all.to_json
    render :action=>"index"
  end

  def terms
  end

  def privacy
  end
end
