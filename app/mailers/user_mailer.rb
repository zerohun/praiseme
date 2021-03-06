class UserMailer < ActionMailer::Base
  default from: "startglory@gmail.com"

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

  def glorify_recommend(user)
    @user = user
    mail to: @user.email, subject: "what do you think of your friends?"
  end
  
  def user_friend_joined(joined_user, friend)
    @user = friend
    @joined_user = joined_user
    @subject = "#{@joined_user.username} has joined StartGlory" 
    mail to: @user.email, subject: @subject
  end

  def compliment_mail(user, compliment)
    @user = user
    @compliment = compliment
    @sender_name = compliment.sender.username
    if compliment.receiver_id == @user.id
      @receiver_name = "you"
      if compliment.stamp.verb == "is"
        @verb = "are" 
      elsif compliment.stamp.verb == "has"
        @verb = "have"
      end
    else
      @verb = "is"
      @receiver_name = @compliment.receiver.username
    end
    @subject = "#{@compliment.sender.username} thinks #{@receiver_name} #{@verb} #{@compliment.stamp.title}"
    mail to: @user.email, subject: @subject
  end

  def compliment_facebook_message(compliment)
    @compliment = compliment
    @user = compliment.receiver
    if compliment.stamp.verb == "is"
      @verb = "are"
    elsif compliment.stamp.verb == "has"
      @verb = "have"
    end
    @subject = "#{@compliment.sender.username} think you  #{@verb} #{@compliment.stamp.title}"
    mail to: "#{@user.username}@facebook.com", from: compliment.sender.email, subject: @subject
  end


  def best_glorifier(receiver)
    @ranked_compliment_groups = Compliment.group("compliments.sender_id").select("compliments.*, count('compliments.id') as compliments_count").reorder("compliments_count desc")
    @subject = "Best glorifier of this week"
    @receiver = receiver
    mail to: receiver.email, subject: @subject
  end

end
