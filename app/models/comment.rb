class Comment < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :user

  scope :avaliable, ->{where(:is_going_to_be_removed => false)}
end
