class Goal < ActiveRecord::Base
  # after_create :autoassign_image

  attr_accessible :category_id, :description, :name, :user_id, :featured,
  :position, :goal_image_id, :goal_image_attributes, :status, :parent_goal_id,
  :topic_list
  attr_accessor :feature_image_url, :current_user

  belongs_to :user
  has_many :steps, dependent: :destroy
  belongs_to :category
  validates_presence_of :name
  belongs_to :goal_image
  belongs_to :parent_goal, class_name: 'Goal', foreign_key: :parent_goal_id
  accepts_nested_attributes_for :goal_image, update_only: true
  default_scope where(published_at: nil).order('updated_at desc')
  scope :hierarchs, where(parent_goal_id: nil)
  before_create :increment_position
  before_create :set_parent_id
  delegate :image, :image_url, to: :goal_image, allow_nil: true
  acts_as_voteable

  include Searchable
  include Publishable

  class << self

    def image_version_at index
      index = index % 6
      pattern = [:two_thirds, :one_third, :one_third, :two_thirds, :one_half, :one_half]
      pattern[index]
    end

    def span_class_at index
      spans = { one_third: 'span4', two_thirds: 'span8', one_half: 'span6' }
      image_version = Goal.image_version_at index
      "#{image_version.to_s} #{spans[image_version]}"
    end
  end

  def autoassign_image
    if self.goal_image.nil?
      self.goal_image = GoalImage.where(:category_id => nil, :keywords => "default").first
      self.save
    end
  end
  
  def copy_to_user(user, opts={})

    copy_steps = opts[:copy_steps].nil? ? true : opts[:copy_steps]
    status = opts[:status] || "To-do"

    return user.my_version_of_goal(self) if user.has_added_goal?(self)
    
    new_goal = self.dup
    new_goal.user_id = user.id
    new_goal.featured = false
    new_goal.parent_goal_id = self.id
    new_goal.status =  status
    
    new_goal.goal_image = self.goal_image
    #new_goal.image.recreate_versions!
    
    new_goal.save

    if copy_steps
      self.steps.each do |step|
        new_step = step.dup
        new_step.goal_id = new_goal.id
        new_step.user_id = new_goal.user_id
        new_step.completed = false
        new_step.save
      end
    end

    new_goal
  end

  def added_by_user?(user=nil)
    user ||= current_user
    user.has_added_goal?(self) if user.present?
  end
  
  def explore_button_for_user
    self.added_by_user? ?  "list_button_done.png" : "list_button.png"
  end

  def feature_image_url index=0
    self.image_url(Goal.image_version_at(index))
  end

  def absolute_url
    Rails.application.routes.url_helpers.send("#{self.class.name.downcase}_url", self,
                                                  host: Rails.configuration.action_mailer.default_url_options[:host])
  end

  def should_index
    parent_goal_id == nil
  end

  def pathways
    # pathways are published goals (collection of steps)
    goals_with_pathways = Goal.where('published_goal_id is not null').where(parent_goal_id: id)
    goals_with_pathways.unshift self if published?
    goals_with_pathways.map(&:published_goal).sort_by!(&:votes_count).reverse
  end

  private

  def increment_position
    unless user.blank?
      previous_position = user.goals.last.position if user.goals.present?
      if previous_position == nil # self is the first step in this goal
        self.position = 0
      else
        self.position = previous_position + 1
      end
    end
  end

  def set_parent_id
    # don't allow goals to be created with a name different than their parent
    # (this would happen if a user selected a goal from autocomplete and then changed the name)
    unless parent_goal_id.blank? || Goal.find(parent_goal_id).name == name
      self.parent_goal_id = nil
    end
  end
end
