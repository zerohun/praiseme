class MailWorker
  include Sidekiq::Worker
  def perform(user_id)
    UserMailer.welcome_mail(User.find(user_id)).deliver!
  end
end
