class SignUpToken < ActiveRecord::Base
  attr_accessible :token, :sent, :user_id, :user
  belongs_to :user
  belongs_to :invite_request
  before_create :generate_token
  delegate :url_helpers, to: 'Rails.application.routes'
  delegate :default_url_options, to: 'Rails.application.config.action_mailer'

  def url
    # ActionMailer::Base.default_url_options[:host]
    # default_url_options
    url_helpers.new_user_registration_url host: default_url_options[:host], token: token
  end

  def active?
    user_id.blank?
  end

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless self.class.where(token: random_token).exists?
    end
  end
end
