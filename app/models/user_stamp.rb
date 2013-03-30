class UserStamp < ActiveRecord::Base

  default_scope {includes(:user, :stamp)}

  belongs_to :stamp
  belongs_to :user

  before_save do |user_stamp|
    if self.changed_attributes.include?(:score) && (self.changed_attributes[:score]/ 100) < (self.score / 100)
      adding_point = (self.changed_attributes[:score] - self. score) / 10
      self.complimented_stamps.update_all("user_stamps.score = user_stamps.score + ?", adding_point)
    end
  end

  def complimeted_stamps
    compliments = Compliment.where :sender_id => self.user_id, :stamp_id => self.stamp_id
    receiver_ids = compliments.map {|compliment|
      compliment.receiver_id
    }
    UserStamp.where(:user_id => receiver_ids, :stamp_id => self.stamp_id)
  end

  def impact
    self.score / 10
  end

  def get_score_from(user_stamp)
    if user_stamp.present?
      self.score = user_stamp.impact
    else
      self.score = self.score + 10
    end
    self.save
  end

  private

end
