class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  geocoder_init Hash.new
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable

  has_many :sns_connections, :dependent => :destroy
  
  has_many :user_news_feeds
  has_many :news_feeds, :as => :notifiable,  :through => :user_news_feeds

  has_many :followings, :foreign_key => :follower_id
  has_many :followees, :through => :followings, :foreign_key => :followee_id

  has_many :being_followed, :foreign_key => :followee_id, :class_name => "Following"
  has_many :followers, :through => :being_followed, :foreign_key => :follower_id 

  has_many :received_compliments, :foreign_key => :receiver_id, :class_name => "Compliment"
  has_many :sent_compliments, :foreign_key => :sender_id, :class_name => "Compliment"

  has_many :user_stamps
  has_many :has_invited_friendships, :foreign_key => :is_invited_by_id, :class_name => "Friendship"
  has_many :is_invited_by_friendships, :foreign_key => :has_invited_id, :class_name => "Friendship"

  has_many :has_invited, :through => :has_invited_friendships, :foreign_key => :has_invited_id
  has_many :is_invited_by, :through => :is_invited_by_friendships, :foreign_key => :is_invited_by_id

  mount_uploader :image, ImageFileUploader

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  #
  
  attr_accessor :sns_connected

  after_create do |user|
    NewsFeed.create :notifiable => user, :action => NewsFeed::ACTION_TYPE[:create]
  end

  def friends
    self.is_invited_by + self.has_invited
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

  def facebook
    sns_connections.where(:provider => "facebook")
    if self.sns_connections.present?
      @facebook ||= Koala::Facebook::API.new(sns_connections.first.oauth_token)
    end
  end


  def facebook_image_url
    sns_connections = self.sns_connections.where(:provider => "facebook")
    if sns_connections.present?
      return "https://graph.facebook.com/#{sns_connections.first.uid}/picture"
    else
      return nil
    end
  end

  def from_omniauth(auth)
    self.email = auth.info.email
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name

    require 'open-uri'

    res = open(auth.info.image)
    file_extension = res.content_type.split('/').last
    file_name = "profile_picture_#{self.id}.#{file_extension}"
    file = File.new("#{Rails.root}/public/upload/#{file_name}", "wb")
    file.write res.read

    profile_image_file = ActionDispatch::Http::UploadedFile.new :filename => file_name,
                                           :type => res.content_type,
                                           :tempfile => file

    self.image = profile_image_file
  end
end
