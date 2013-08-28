class AddCompletedToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :completed, :boolean, :default=>false
  end
end
