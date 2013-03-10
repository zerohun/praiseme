class NewsFeed < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true 
  ACTION_TYPE = {
    :create => 1,
    :update => 2,
    :destroy => 3
  }

  def action_type
    self[:action]
  end
end
