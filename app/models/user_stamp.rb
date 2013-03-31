class UserStamp < ActiveRecord::Base

  default_scope {includes(:user, :stamp)}

  belongs_to :stamp
  belongs_to :user

  before_save do |user_stamp|
    new_rank = UserStamp.where("user_stamps.score > ?", self.score).count
    if self.rank.present? & (self.rank != new_rank)
      if new_rank > self.rank
        NewsFeed.create_for_gainig_rank self
      end
      self.previous_rank = self.rank
      self.rank = new_rank
    end
    if self.changed_attributes.has_key?("score") && (self.changed_attributes["score"]/ 100) < (self.score / 100)
      adding_point = (self.score - self.changed_attributes["score"]) / 10
      user_stamp.complimented_stamps.update_all("user_stamps.score = user_stamps.score + #{adding_point}")
      NewsFeed.create_for_jumping_score user_stamp
    end
  end

  def self.add_up_score_from_compliment(compliment)
    stamp_id = compliment.stamp_id
    receiver_user_stamp = compliment.receiver.user_stamps.find_or_create_by(:stamp_id => stamp_id)
    sender_user_stamp = compliment.sender.user_stamps.find_by(:stamp_id => stamp_id)
    receiver_user_stamp.get_score_from sender_user_stamp
  end

  def complimented_stamps
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
