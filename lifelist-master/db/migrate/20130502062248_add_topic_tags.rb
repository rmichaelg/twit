class AddTopicTags < ActiveRecord::Migration
  def up
    list = ["Adventure","Entertainment","Travel","Habits","Spiritual","Athletics","Health & Nutrition","Education","Skills","Art","Music & Dance","Literature","Financial","Professional","Altruistic","Environment","Animals","Family","Relationships"]

    list.each do |tag|
      ActsAsTaggableOn::Tag.new(:name => tag).save
    end
  end

  def down
  end
end
