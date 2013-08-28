class AddFeaturedToGoal < ActiveRecord::Migration
  def change
    add_column :goals, :featured, :boolean, :default=>false
  end
end
