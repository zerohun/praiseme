class Compliment < ActiveRecord::Base

  default_scope {includes(:sender, :receiver, :stamp)}

  has_many :comments, :as => :target

  has_one :news_feed, :as => :notifiable, :dependent => :destroy

  belongs_to :sender , :foreign_key => :sender_id, :class_name => "User"
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => "User"
  belongs_to :stamp

  validate :shoundnt_compliment_himself
  validates_presence_of :sender_id, :stamp_id, :receiver_id
  validates_uniqueness_of :sender_id, :scope => [:receiver_id, :stamp_id]

  after_create do |compliment|
    NewsFeed.create_for_compliment compliment
    UserStamp.add_up_score_from_compliment compliment
  end
  def shoundnt_compliment_himself
    if self.sender_id == self.receiver_id
      self.errors[:sender_id] = "You can't compliment youself"
      self.errors[:receiver_id] = "You can't compliment youself"
    end
  end
end
