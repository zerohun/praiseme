class UserNewsFeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_feed

end
