class Compliment < ActiveRecord::Base
  belongs_to :sender , :foreign_key => :sender_id, :class_name => "User"
  belongs_to :receiver, :foreign_key => :receiver_id, :class_name => "User"
  belongs_to :stamp

  after_create do |compliment|
    NewsFeed.create :notifiable => compliment, :action => NewsFeed::ACTION_TYPE[:create]
  end
end
