class AddParentGoalIdToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :parent_goal_id, :integer
  end
end
