class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sns_connections
  
  has_many :user_news_feeds
  has_many :news_feeds, :as => :notifiable,  :through => :user_news_feeds

  has_many :followings, :foreign_key => :follower_id
  has_many :followees, :through => :followings, :foreign_key => :followee_id

  has_many :being_followed, :foreign_key => :followee_id, :class_name => "Following"
  has_many :followers, :through => :being_followed, :foreign_key => :follower_id

  has_many :received_compliments, :foreign_key => :receiver_id, :class_name => "Compliment"
  has_many :sent_compliments, :foreign_key => :sender_id, :class_name => "Compliment"

  validates_presence_of :email


  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  #
  
  attr_accessor :sns_connected

  after_create do |user|
    NewsFeed.create :notifiable => user, :action => NewsFeed[:create]
  end

  def password_required?
    super && self.sns_connected
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
