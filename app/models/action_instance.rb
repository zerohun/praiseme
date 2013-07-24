class ActionInstance < ActiveRecord::Base
  belongs_to :content, :polymorphic => true
  validates_presence_of :instance_id
end
