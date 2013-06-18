class Comment < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :user

  def is_destroyable_by?(user)
    self.user == user || (self.target.methods.include?(:receiver) && self.target.receiver == user)
  end
end
