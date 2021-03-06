class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  geocoder_init Hash.new
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :token_authenticatable

  has_many :sns_connections, :dependent => :destroy
  
  has_many :user_news_feeds
  has_many :my_user_news_feeds
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

  before_save :ensure_authentication_token

  mount_uploader :image, ImageFileUploader

  USER_TYPE={
    :coming => 0,
    :joined => 1
  
  }


  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  #
  
  attr_accessor :sns_connected

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
    if self[:gender] == 1
      return 'male'
    elsif self[:gender] == 2
      return 'female'
    else
      return nil
    end
  end

  def from_graph(me)
    self.email = me["email"]
    self.first_name = me["first_name"]
    self.last_name = me["last_name"]
    self.username = me["name"]
    if me["gender"] == "male"
      self.gender = 0
    else
      self.gender = 1
    end
  end

  def from_omniauth(auth)
    self.email = auth.info.email
    if self.email.blank?
      self.email = "#{auth.uid}@facebook.com"
    end
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
    self.facebook_username = auth.info.nickname if auth.info.nickname.present?
    self.local = auth.info.locale
    if auth.extra.raw_info.gender == "male"
      self.gender = 1
    elsif auth.extra.raw_info.gender == "female"
      self.gender = 2
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
    # very sensitive part! be careful!!!
    sns_connection = self.sns_connections.where(:provider => "facebook").first
    uids = []
    if sns_connection.has_invited_friends == false
      sns_connection.update_attribute :has_invited_friends, true
      facebook_friends = self.facebook.get_connections("me", "friends")
      facebook_friends.each do |friend|
        uids << friend["id"]
        begin
          friend_sns_connection = SnsConnection.where(:uid => friend["id"], :provider => "facebook").first
          if friend_sns_connection.present?
            friend_ids = Friendship.where(:is_invited_by_id => self.id).pluck("has_invited_id")
            if friend_ids.include?(friend_sns_connection.user_id) == false
              self.has_invited_ids = (friend_ids + [friend_sns_connection.user_id]).uniq
            end
            Following.find_or_create_by :follower => self, :followee => friend_sns_connection.user

          else
            #friend_info = self.facebook.get_object friend["id"]
            #if friend_info["gender"] == "male"
              #gender = 0
            #elsif friend_info["gender"] == "female"
              #gender = 1
            #else
              #gender = nil
            #end
            invited_user = User.find_or_create_by :username => friend["name"], :email => "#{friend["id"]}@facebook.com", :status => User::USER_TYPE[:pending]#, :first_name => friend_info["first_name"], :last_name => friend_info["last_name"]
            if invited_user.facebook_username.blank? || invited_user.gender.blank?
              friend_facebook = self.facebook.get_object(friend["id"])
              invited_user.facebook_username = friend_facebook["username"]
              invited_user.gender = 1 if friend_facebook["gender"] == "male"
              invited_user.gender = 2 if friend_facebook["gender"] == "female"
              invited_user.local = friend_facebook["locale"]
              invited_user.save
            end

            Friendship.find_or_create_by :is_invited_by_id => self.id, :has_invited_id => invited_user.id
            sns_connection = invited_user.sns_connections.find_or_initialize_by :uid => friend["id"], :provider => "facebook"
            sns_connection.save(:validate => false) if sns_connection.new_record?
            Following.find_or_create_by :follower => self, :followee => invited_user
          end


        rescue Exception => e
          puts e.message  
          puts e.backtrace.inspect  
        end
      end

      score_hash = {}
      score_hash = score_hash + FacebookDataHelper.get_score_hash(self.facebook, "posts")
      score_hash = score_hash + FacebookDataHelper.get_score_hash(self.facebook, "posts", {:like_score => 2, :comment_score => 3, :total_page_num => 5})
      score_hash = score_hash + FacebookDataHelper.get_score_hash_from_friend_list(self.facebook, 20)


      score_hash.each_pair do |k,v|
        if uids.include?(k)
          self.followings.joins(:followee => :sns_connections).readonly(false).find_by("sns_connections.uid = ?", k).update_attribute :rank, v
        end
      end

      UserMailer.complete_inviting_friends(self).deliver!
    end
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

  def user_point
    UserStamp.where(:user_id => self[:id]).sum("score") 
  end


 # def convert_coming_from_joined
 #   user = self
 #   NewsFeed.create_for_new_user(user)
 #   begin 
 #     user.facebook.put_wall_post("Joined Startglory", :link => "http://startglory.com", :picture => "http://startglory.com/startglorylogo_square_9090.jpg", :name => "Startglory", :caption => "Startglory", :description => "Get compliments from your friends")
 #   rescue Exception
 #   end
 #   user.status = 1
 #
 # end

  def save_and_prepare_for_new_user
    user = self

    user.user_admin_type = 2 if user.email == "choi0hun@gmail.com" || user.email == "pbs52@hanmail.net"
    user.status = 1
    user.joined_at = Time.now
    user.save
    user.reload
    sns_connection = user.sns_connections.where(:provider => "facebook").first
    user.delay.invites_friends_automatically if sns_connection.has_invited_friends == false
    
 # needs chang UI (remove comments after change ui)

 # comment End  
    
    #begin 
      #user.facebook.put_wall_post("Joined Startglory", :link => "http://startglory.com", :picture => "http://startglory.com/startglorylogo_square_9090.jpg", :name => "Startglory", :caption => "Startglory", :description => "Get compliments from your friends")
    #rescue Exception
    #end

    NewsFeed.create_for_new_user(user)
    NotifierWorker.perform_async "new_user", {"user_id" => user.id}
  end

end
