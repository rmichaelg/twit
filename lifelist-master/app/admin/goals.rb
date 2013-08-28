ActiveAdmin.register Goal do
  filter :user_id
  filter :name
  before_filter :set_pagination

  batch_action :feature do |selection|
    Goal.find(selection).each do |goal|
      goal.featured = true
      goal.save
    end
    redirect_to collection_path, :notice => "Goals featured!"
  end

  index do
    selectable_column
    column "id"
    column "goal_image" do |i|
      image_tag(i.image_url, :width=>"100") if i.goal_image
    end
    column "name"
    column "user" do |u|
      u.user.username if u.user
    end
    column "featured"
    column "created_at"
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :user
      f.input :category
      f.input :goal_image
      f.input :topic_list, :as => :check_boxes,
              :collection => ActsAsTaggableOn::Tag.all.map(&:name)
      f.input :name
      f.input :description
      f.input :featured
      f.input :position
      f.input :status
    end
    f.actions
  end

  controller do
    def scoped_collection
      Goal.hierarchs
    end

    private

    def set_pagination
      @per_page = 100
    end
  end
end
