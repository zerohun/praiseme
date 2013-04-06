class Friendship < ActiveRecord::Base
  belongs_to :is_invited_by, :class_name => User
  belongs_to :has_invited, :class_name => User

end
