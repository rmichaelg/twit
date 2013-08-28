class RevertGoalGoalImageRelationship < ActiveRecord::Migration
  def change
    add_column  :goals, :goal_image_id, :integer
    remove_column  :goal_images, :goal_id
  end
end
