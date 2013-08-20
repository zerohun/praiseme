class Compliment < ActiveRecord::Base

  default_scope {includes(:sender, :receiver, :stamp)}

  has_many :comments, :as => :target, :dependent => :destroy

  has_one :news_feed, :as => :notifiable, :dependent => :destroy
  has_one :action_instance, :as => :content, :dependent => :destroy
 

  belongs_to :sender , :foreign_key => :sender_id, :class_name => "User"
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => "User"
  belongs_to :stamp
  #belongs_to :user_stamp

  #validate :shoundnt_compliment_himself
  validates_presence_of :sender_id, :stamp_id, :receiver_id 
  #validates_uniqueness_of :sender_id, :scope => [:receiver_id, :stamp_id]

  validates_length_of :description, :maximum => 400

  before_save do |compliment|
    user_stamp = UserStamp.find_or_initialize_by(:user_id => compliment.sender_id, :stamp_id => compliment.stamp_id)

    duplicated_compliment = Compliment.where(:stamp_id => compliment.stamp_id, :sender_id => compliment.sender_id, :receiver_id => compliment.receiver_id).where("compliments.impact_score > 0").last
    if duplicated_compliment.present? && duplicated_compliment.impact_score == user_stamp.impact
      compliment.impact_score = 0
    else
      compliment.impact_score = 1
    end

  end

  after_create do |compliment|
    NewsFeed.delay.create_for_compliment compliment
    user_stamp = UserStamp.where(:stamp_id => compliment.stamp_id, :user_id => compliment.receiver_id).first
    if user_stamp.blank?
      user_stamp = UserStamp.create(:stamp_id => compliment.stamp_id, :user_id => compliment.receiver_id)
    end
    user_stamp.refresh_score
  end

  before_destroy do |compliment|
    begin 
      compliment.sender.facebook.delete_object(compliment.action_instance.instance_id) if compliment.action_instance.present?
    rescue Exception
    end
  end

  after_destroy do |compliment|
    user_stamp = UserStamp.where(:stamp_id => compliment.stamp_id, :user_id => compliment.receiver_id).first
    user_stamp.refresh_score
  end

  def is_destroyable_by?(user)
    self.receiver == user || self.sender == user
  end

  def shoundnt_compliment_himself
    if self.sender_id == self.receiver_id
      self.errors[:sender_id] = "You can't compliment youself"
      self.errors[:receiver_id] = "You can't compliment youself"
    end
  end

  def description
    if self[:description].blank?
      "I think #{self.receiver.username} is '#{self.stamp.title}'"
    else
      super
    end
  end

  def object_url(host)
    "http://#{host}/compliments/#{self.id}"
  end

  def post_og(og_params_hash)
    begin
      res = self.sender.facebook.put_connections "me", "#{$fb_namespace}:glorify", og_params_hash
    rescue Exception => e
      begin
        res = self.sender.facebook.put_connections "me", "#{$fb_namespace}:glorify", :profile => og_params_hash["profile"]
      rescue Exception => e
        res = nil
      end
    end

    self.create_action_instance :instance_id => res["id"] if res.present?
    return res
  end
end
