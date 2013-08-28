module Publishable
  extend ActiveSupport::Concern

  included do
    # for setting published_at directly
    # attr_accessor :publish
    # before_save :publish_or_unpublish
    belongs_to :published_goal, class_name: 'Goal', foreign_key: :published_goal_id

    def publish!
      unpublish! if published?
      @published_goal = self.dup
      @published_goal.published_at = Time.now 

      steps.each do |step|
        published_step = step.dup
        published_step.goal_id = nil
        @published_goal.steps << published_step
      end
      @published_goal.save!
      self.published_goal = @published_goal
      save!
    end

    def unpublish!
      return unless published?
      published_goal.destroy
      update_column(:published_goal_id, nil)
    end

    def published_goal
      if published?
        Goal.unscoped.find(published_goal_id)
      else
        nil
      end
    end

    def published?
      published_goal_id.present?
    end

    def published_at
      return published_goal.try(:published_at) if published?
      super
    end
  end

  private

  def publish_or_unpublish
    if persisted? && published_at_changed?
      published_at.present? ? publish! : unpublish!
    end
  end
end
