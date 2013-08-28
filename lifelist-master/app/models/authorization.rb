class Authorization < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :auth_hash, :provider, :token, :uid
  validates_uniqueness_of :uid, scope: :provider
  attr_accessible :auth_hash, :provider, :token, :uid, :user
  serialize :auth_hash

  def self.find_from_callback_hash hash
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end
end
