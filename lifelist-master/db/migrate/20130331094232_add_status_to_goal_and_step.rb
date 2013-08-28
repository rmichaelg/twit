class AddStatusToGoalAndStep < ActiveRecord::Migration
  def change
    add_column :goals, :status, :string, :default=>"To-do"
    add_column :steps, :status, :string, :default=>"To-do"
  end
end
