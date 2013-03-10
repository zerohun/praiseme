class NewsFeed < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true
  ACTION_TYPE = {
    :create => 1,
    :update => 2,
    :destroy => 3
  }

  def action_type
    ACTION_TYPE.key(self.action)
  end

  def to_s
    if self.notifiable_type == "Compliment" && self.action_type == :create
      "#{self.notifiable.sender.username} gave stamp of #{self.notifiable.stamp.title} to #{self.notifiable.receiver.username}"
    end
  end
end
