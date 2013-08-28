class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :avatar, :remote_avatar_url, :first_name, :last_name,
                  :username, :email, :password, :password_confirmation, :remember_me,
                  :has_password, :receive_email, :gender, :location, :about, :birthday,
                  :sign_up_token
  has_many :goals
  has_many :steps
  has_one :sign_up_token
  mount_uploader :avatar, AvatarUploader
  after_create :add_to_mailchimp
  acts_as_voter
  has_karma(:goals, as: :submitter)

  include Oauthable
  include Searchable

  RESERVED_URLS = %w(
    user
    users
    account
    avatar
    messages
    friends
    profile
    profiles
    signup
    signout
    signin
    goals
    terms
    privacy
    goal
    gear
    lifelist
    admin
    about
    faq
    settings
  )

  validates_uniqueness_of :username, allow_blank: true
  validates_format_of :username, with: /^[a-zA-Z0-9\-.]*$/, allow_blank: true
  validates_exclusion_of :username, in: RESERVED_URLS, allow_blank: true

  def goals_with_name(goal_name)
    self.goals.select{|g|  g.name.casecmp(goal_name)==0}
  end

  def has_added_goal?(goal)
    goal.user_id==self.id || self.goals.select{|g| g.parent_goal_id==goal.id}.any?
  end

  def my_version_of_goal(goal)
    if goal.user_id==self.id
      goal # this goal belongs to me
    elsif goal.id
      self.goals.select{|g| g.parent_goal_id==goal.id}.first # my forked version of the goal
    end
  end

  def goals_listed
    # used to default the listed button the explore page
    listed_goals = self.goals.select{|g| g.status != "Done"}
    (listed_goals.map{|g| g.id} + listed_goals.map{|g| g.parent_goal_id}).uniq.delete_if{ |id| id == nil }
  end

  def goals_done
    # used to default the done button the explore page
    done_goals = self.goals.select{|g| g.status == "Done"}
    (done_goals.map{|g| g.id} + done_goals.map{|g| g.parent_goal_id}).uniq.delete_if{ |id| id == nil }
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def absolute_url
    UsersController.helpers.profile_url(self)
  end

  def swiftype_fields
    [{name: 'name', value: full_name, type: 'string'},
     {name: 'url', value: absolute_url, type: 'enum'},
     {name: 'avatar_thumb', value: avatar_url(:thumb), type: 'enum'},
     {name: 'created_at', value: created_at.iso8601, type: 'date'}]
  end

  private

  def add_to_mailchimp
    if self.receive_email
      gibbon = Gibbon.new('9a18971c4966df4d986d9a50b42ae48a-us6')
      gibbon.list_subscribe({id: 'f513c9d815', email_address: self.email, merge_vars: {:FNAME => self.first_name, :LNAME => self.last_name}})
    end
  end
end
