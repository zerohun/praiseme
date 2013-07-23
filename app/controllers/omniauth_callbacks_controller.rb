class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    cookies['need_to_check_location'] = true
    sns_connection = SnsConnection.from_omniauth(auth)
    user = sns_connection.user
    if sns_connection.persisted? && user.present?
      sns_connection.save
      user.from_omniauth(auth)

      if user.status != 1
        NewsFeed.create_for_new_user(user)
        begin 
          user.facebook.put_wall_post("Joined Startglory", :link => "http://startglory.com", :picture => "http://startglory.com/startglorylogo_square_9090.jpg", :name => "Startglory", :caption => "Startglory", :description => "Get compliments from your friends")
        rescue Exception => e
        end
        user.status = 1
      end
      user.save if user.changed
      user = user.reload
      user.delay.invites_friends_automatically if sns_connection.has_invited_friends == false
      sign_in_and_redirect user, notice: "Signed in!"
    else
      if sns_connection.provider == "facebook"
        user = User.new
        user.from_omniauth(auth)
        user.status = 1
        user.user_admin_type = 2 if user.email == "choi0hun@gmail.com" || user.email == "pbs52@hanmail.net"
        user.save
        sns_connection.update_attribute :user_id, user.id
        sign_in user
        MailWorker.perform_async(user.id)
        user = user.reload
        user.delay.invites_friends_automatically if sns_connection.has_invited_friends == false
        NewsFeed.create_for_new_user(user)
        begin 
          user.facebook.put_wall_post("Joined Startglory", :link => "http://startglory.com", :picture => "http://startglory.com/startglorylogo_square_9090.jpg", :name => "Startglory", :caption => "Startglory", :description => "Get compliments from your friends")
        rescue Exception => e
        end
        if cookies[:last_page_url].present?
          last_page_url = cookies[:last_page_url]
          cookies[:last_page_url] = nil
          redirect_to last_page_url
        else
          redirect_to root_url
        end

      else
        session["devise.user_attributes"] = sns_connection.attributes
        session["sns_connection_id"] = sns_connection.id
        redirect_to new_user_registration_url
      end
    end
  end
  alias_method :facebook, :all
end
