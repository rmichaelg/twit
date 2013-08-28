class AddImageToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :image, :string
  end
end
