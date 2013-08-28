class InviteRequest < ActiveRecord::Base
  attr_accessible :email, :username
  has_one :sign_up_token
  validates :email, presence: true, uniqueness: true, email: true
  validates :username, presence: true, uniqueness: true
  validates_format_of :username, with: /^[a-zA-Z0-9\-.]*$/, allow_blank: true
  validates_exclusion_of :username, in: User::RESERVED_URLS, allow_blank: true
  validate :user_validator

  private

  def user_validator
    if User.find_by_email(email)
      errors.add(:email, 'has already been taken') unless errors[:email].include? 'has already been taken'
    end
    if User.find_by_username(username)
      errors.add(:username, 'has already been taken') unless errors[:email].include? 'has already been taken'
    end
  end
end
