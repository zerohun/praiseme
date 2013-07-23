class Compliment < ActiveRecord::Base

  default_scope {includes(:sender, :receiver, :stamp)}

  has_many :comments, :as => :target, :dependent => :destroy

  has_one :news_feed, :as => :notifiable, :dependent => :destroy
 

  belongs_to :sender , :foreign_key => :sender_id, :class_name => "User"
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => "User"
  belongs_to :stamp
  #belongs_to :user_stamp

  validate :shoundnt_compliment_himself
  validates_presence_of :sender_id, :stamp_id, :receiver_id 
  validates_uniqueness_of :sender_id, :scope => [:receiver_id, :stamp_id]

  validates_length_of :description, :maximum => 400

  before_save do |compliment|
    user_stamp = UserStamp.where(:user_id => compliment.sender_id, :stamp_id => compliment.stamp_id).first
    if user_stamp.present?
      compliment.impact_score = user_stamp.impact
    else
      compliment.impact_score = 1
    end
  end

  after_create do |compliment|
    NewsFeed.delay.create_for_compliment compliment
    UserStamp.add_up_score_from_compliment compliment
  end

  after_destroy do |compliment|
    user_stamp = UserStamp.where(:stamp_id => compliment.stamp_id, :user_id => compliment.receiver_id).first
    user_stamp.reduce_score_from_deleting_compliment compliment
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
end
