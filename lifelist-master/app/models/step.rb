class Step < ActiveRecord::Base
  attr_accessible :description, :name, :user_id, :goal_id, :position, :completed, :status, :url, :image, :remove_image
  belongs_to :user
  belongs_to :goal
  default_scope order('position asc')
  before_create :increment_position
  mount_uploader :image, StepImageUploader

  def position=(value)
    value = value.to_i if value
    unless value == self.position || self.new_record?
      if value > self.position
        condition, change = "position <= ? and position > ? and id != ?", -1
      else
        condition, change = "position >= ? and position < ? and id != ?", 1
      end
      self.goal.steps.where(condition, value, self.position, self.id).update_all "position = position + #{change}"
    end
    super value
  end

  private

  def increment_position
    return if goal.blank?

    previous_position = goal.steps.last.position if goal.steps.present?
    if previous_position == nil # self is the first step in this goal
      self.position = 0
    else
      self.position = previous_position + 1
    end
  end
end
