class GoalImage < ActiveRecord::Base
  VERSIONS = [:one_third, :two_thirds, :one_half]

  attr_accessible :category_id, :user_id, :keywords, :image, :remote_image_url
  attr_accessor :one_half_x, :one_half_y, :one_half_w, :one_half_h,
                :one_third_x, :one_third_y, :one_third_w, :one_third_h,
                :two_thirds_x, :two_thirds_y, :two_thirds_w, :two_thirds_h
  attr_accessible :one_half_x, :one_half_y, :one_half_w, :one_half_h,
                  :one_third_x, :one_third_y, :one_third_w, :one_third_h,
                  :two_thirds_x, :two_thirds_y, :two_thirds_w, :two_thirds_h
  mount_uploader :image, ImageUploader
  belongs_to :user
  belongs_to :category
  has_many :goals
  after_update :recreate_image_versions, if: :cropping?

  def cropping? version=nil
    if version.present?
      self.send("#{version}_x").present?
    else
      cropping?(VERSIONS[0]) || cropping?(VERSIONS[1]) || cropping?(VERSIONS[2])
    end
  end

  def name
    self.keywords
  end

  private

  def recreate_image_versions
    VERSIONS.each do |version|
      image.recreate_versions!(version) if cropping? version
    end
  end
end
