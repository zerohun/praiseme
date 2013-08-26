class NotifierWorker
  include Sidekiq::Worker
  def perform(notifier_name, params)
    self.send(notifier_name, params)
  end

  def new_user(params)
    user = User.find(params["user_id"])
    UserMailer.welcome_mail(user).deliver!
  end


  def new_compliment(params)
    compliment = Compliment.find(params["compliment_id"])
    users_to_be_notified = compliment.users_to_be_notified
    news_feed = NewsFeed.create :notifiable => compliment, :action => NewsFeed::ACTION_TYPE[:create]
    users_to_be_notified.each do |user|
      user.user_news_feeds.create :news_feed => news_feed
      UserMailer.compliment_mail(user, compliment).deliver!
    end
  end
end

