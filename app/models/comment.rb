class Comment < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :user

  validates_length_of :content, :maximum => 200

  has_one :news_feed, :as => :notifiable, :dependent => :destroy

  def is_destroyable_by?(user)
    self.user == user || (self.target.methods.include?(:receiver) && self.target.receiver == user)
  end


  after_create do |comment|
    NewsFeed.delay.create_for_new_comment comment
  end
  
end
