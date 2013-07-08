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

  has_many :followings, :foreign_key => :follower_id, :dependent => :destroy
  has_many :followees, :through => :followings, :foreign_key => :followee_id

  has_many :being_followed, :foreign_key => :followee_id, :class_name => "Following"
  has_many :followers, :through => :being_followed, :foreign_key => :follower_id 

  has_many :received_compliments, :foreign_key => :receiver_id, :class_name => "Compliment"
  has_many :sent_compliments, :foreign_key => :sender_id, :class_name => "Compliment", :dependent => :destroy

  has_many :user_stamps, :dependent => :destroy
  has_many :has_invited_friendships, :foreign_key => :is_invited_by_id, :class_name => "Friendship", :dependent => :destroy
  has_many :is_invited_by_friendships, :foreign_key => :has_invited_id, :class_name => "Friendship"

  has_many :has_invited, :through => :has_invited_friendships, :foreign_key => :has_invited_id
  has_many :is_invited_by, :through => :is_invited_by_friendships, :foreign_key => :is_invited_by_id

  default_scope -> {joins(:sns_connections).select("users.*, sns_connections.uid, sns_connections.oauth_token")}

  mount_uploader :image, ImageFileUploader

  USER_TYPE={
    :coming => 0,
    :joined => 1
  
  }


  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  #
  
  attr_accessor :sns_connected

  after_create do |user|
    NewsFeed.create :notifiable => user, :action => NewsFeed::ACTION_TYPE[:create]
  end

  def friends
    user_ids = User.joins("INNER JOIN friendships ON users.id = friendships.has_invited_id or users.id = friendships.is_invited_by_id").
                    where("(friendships.has_invited_id = ? or friendships.is_invited_by_id = ?) and users.id != ? ", self.id, self.id, self.id).
                    select("users.id").all.uniq.map {|u| u.id}

    User.where(:id => user_ids)
  end

  def user_type
    return User::USER_TYPE.key(self.status)
  end

  def password_required?
    self.sns_connected
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params.permit(:introduce), *options)
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

  def object_url(host_name)
    "http://#{host_name}/user_profiles/#{self.id}"
  end

  def image_url(width: 200, height: 200)
    "https://graph.facebook.com/#{self.uid}/picture?width=#{width}&height=#{height}"
  end


  def gender
    if self[:gender] == 0
      return 'male'
    elsif self[:gender] == 1
      return 'female'
    else
      return nil
    end
  end


  def from_omniauth(auth)
    self.email = auth.info.email
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
    if auth.extra.raw_info.gender == "male"
      self.gender = 0
    else
      self.gender = 1
    end


    #require 'open-uri'

    #res = open(auth.info.image)
    #file_extension = res.content_type.split('/').last
    #file_name = "profile_picture_#{self.id}.#{file_extension}"
    #file = File.new("#{Rails.root}/public/upload/#{file_name}", "wb")
    #file.write res.read

    #profile_image_file = ActionDispatch::Http::UploadedFile.new :filename => file_name,
                                           #:type => res.content_type,
                                           #:tempfile => file

    #self.image = profile_image_file
  end

  def invites_friends_automatically

    facebook_friends = self.facebook.get_connections("me", "friends")
    facebook_friends.each do |friend|
      friend_sns_connection = SnsConnection.where(:uid => friend["id"], :provider => "facebook").first
      if friend_sns_connection.present?
        friend_ids = Friendship.where(:is_invited_by_id => self.id).pluck("has_invited_id")
        if friend_ids.include?(friend_sns_connection.user_id) == false
          self.has_invited_ids = (friend_ids + [friend_sns_connection.user_id]).uniq
        end
      else
        friend_info = self.facebook.get_object friend["id"]

        if friend_info["gender"] == "male"
          gender = 0
        elsif friend_info["gender"] == "female"
          gender = 1
        else
          gender = nil
        end

        invited_user = self.has_invited.create :username => friend["name"], :email => "#{friend["id"]}@facebook.com", :status => User::USER_TYPE[:pending], :gender => gender

        sns_connection = invited_user.sns_connections.new :uid => friend["id"], :provider => "facebook"
        sns_connection.save(:validate => false)
      end
      Following.create :follower => self, :followee => invited_user
    end
    self.sns_connections.where(:provider => "facebook").first.update_attribute :has_invited_friends, true
    NewsFeed.create_for_new_user self
  end


  def introduce
    if self[:introduce].present?
      return self[:introduce]
    elsif self.job.present? || self.school.present?
      return [self.job, self.school].compact.join("\n\n").html_safe
    else
      nil
    end
  end

  def introduce_html
    if self.introduce.present?
      self.introduce.gsub("\n","<br>").html_safe
    else
      nil
    end
  end


  def username
    if self[:username].present?
      self[:username]
    else
      "#{self[:first_name]} #{self[:last_name]}"
    end
  end

end
