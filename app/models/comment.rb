class Comment < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :user

  validates_length_of :content, :maximum => 200

  def is_destroyable_by?(user)
    self.user == user || (self.target.methods.include?(:receiver) && self.target.receiver == user)
  end
end
