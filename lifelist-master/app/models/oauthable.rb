module Oauthable
  extend ActiveSupport::Concern

  module ClassMethods
    def new_from_oauth auth_hash, sign_up_token
      birthday = auth_hash.extra.raw_info.birthday.split('/').map(&:to_i)
      birthday = DateTime.new(birthday[2], birthday[0], birthday[1])
      facebook_avatar_url = auth_hash[:info][:image].gsub!('type=square', 'type=large')
      password = Devise.friendly_token

      user_fields = {
        first_name: auth_hash.extra.raw_info.first_name,
        last_name:  auth_hash.extra.raw_info.last_name,
        username:   auth_hash.extra.raw_info.username,
        email:      auth_hash.extra.raw_info.email,
        birthday:   birthday,
        location:   auth_hash.extra.raw_info.try(:location).try(:name),
        gender:     auth_hash.extra.raw_info.gender.capitalize,
        about:      auth_hash.extra.raw_info.bio,
        remote_avatar_url: facebook_avatar_url,
        password: password,
        password_confirmation: password,
        has_password: false,
        sign_up_token: sign_up_token,
        authorizations_attributes: [{auth_hash: auth_hash,
                                      provider: auth_hash.provider,
                                      token: auth_hash.credentials.token,
                                      uid: auth_hash.uid}]
      }

      User.new(user_fields)
    end
  end

  included do
    devise :omniauthable
    has_many :authorizations, dependent: :destroy
    accepts_nested_attributes_for :authorizations
    attr_accessible :authorizations_attributes
    before_validation :reject_invalid_oauth_username # if username from oauth provider is not unique, just don't save it

    def add_authorization auth_hash
      self.update_attributes authorizations_attributes: [{auth_hash: auth_hash,
                                                          provider: auth_hash.provider,
                                                          token: auth_hash.credentials.token,
                                                          uid: auth_hash.uid}]
    end

    def has_authorization? provider
      self.authorizations.find_by_provider(provider).present?
    end

    private

    def reject_invalid_oauth_username
      self.username = nil if self.class.where(username: self.username).exists?
    end
  end
end
