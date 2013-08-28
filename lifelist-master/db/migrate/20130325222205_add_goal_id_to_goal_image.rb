class AddGoalIdToGoalImage < ActiveRecord::Migration
  def change
    remove_column  :goals, :goal_image_id
    add_column  :goal_images, :goal_id, :integer
  end
end
