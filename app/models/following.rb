class Following < ActiveRecord::Base
  belongs_to :follower, :class_name => User
  belongs_to :followee, :class_name => User

  validates_presence_of :followee, :scope => [:follower]
end
