class UserMailer < ActionMailer::Base
  default from: "startglory@startglory.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_mail.subject
  #
  def welcome_mail(user)
    mail to: user.email,
         subject: "Welcome to Startglory"

  end

  def complete_inviting_friends(user)
    mail to: user.email,
         subject: "We just brought all of your facebook friends"
  end
end