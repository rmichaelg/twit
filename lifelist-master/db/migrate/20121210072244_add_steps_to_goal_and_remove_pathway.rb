class AddStepsToGoalAndRemovePathway < ActiveRecord::Migration
  def change
    add_column :steps, :goal_id, :integer
    remove_column :steps, :pathway_id
    drop_table :pathways
  end
end
