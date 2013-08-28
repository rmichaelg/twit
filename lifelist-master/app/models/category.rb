class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :goals
  has_many :goal_images
end
