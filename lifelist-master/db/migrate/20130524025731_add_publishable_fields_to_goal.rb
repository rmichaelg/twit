class AddPublishableFieldsToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :published_at, :datetime
    add_column :goals, :published_goal_id, :integer
  end
end
