class Compliment < ActiveRecord::Base
  belongs_to :sender , :foreign_key => :sender_id, :class_name => "User"
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => "User"
  belongs_to :stamp

  validate :shoundnt_compliment_himself
  validates_uniqueness_of :sender_id, :scope => [:receiver_id, :stamp_id]

  after_create do |compliment|
    NewsFeed.create :notifiable => compliment, :action => NewsFeed::ACTION_TYPE[:create]
  end
  def shoundnt_compliment_himself
    if self.sender_id == self.receiver_id
      self.errors[:sender_id] = "You can't compliment youself"
      self.errors[:receiver_id] = "You can't compliment youself"
    end
  end
end
