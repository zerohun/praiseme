class Comment < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :user

  validates_length_of :content, :maximum => 200

  has_one :news_feed, :as => :notifiable, :dependent => :destroy
  has_one :action_instance, :as => :content, :dependent => :destroy

  def is_destroyable_by?(user)
    self.user == user || (self.target.methods.include?(:receiver) && self.target.receiver == user)
  end


  after_create do |comment|
    NewsFeed.delay.create_for_new_comment comment
  end

  before_destroy do |comment|
    begin 
      comment.user.facebook.delete_object(comment.action_instance.instance_id) if comment.action_instance.present?
    rescue Exception
    end
  end
end
