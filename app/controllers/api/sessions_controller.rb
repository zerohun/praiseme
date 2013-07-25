class Api::SessionsController < ActionController::Base
  #skip_before_action :authenticate_user!
  #skip_before_action :store_current_page_url
  
  def create
    begin
      oauth_token = params[:oauth_token]
      graph = Koala::Facebook::API.new(oauth_token)
      me = graph.get_object("me")
      sns_connection = SnsConnection.sign_in_or_up(me: me, oauth_token: oauth_token)
      user = sns_connection.user
      render :json => {:auth_token => user.authentication_token}
    rescue Exception => e
      puts e.class
      puts e.message
      puts e.backtrace
      render :json => {:auth_token => nil}
    end
  end
end
