class SnsConnection < ActiveRecord::Base
  belongs_to :user

  after_save do |sns_connection|
    if sns_connection.user.present? && self.oauth_token.present?
      user = self.user

      user_info = user.facebook.get_object("me")

      if user_info["work"].present?
        employer = user_info["work"].first["employer"]["name"]
        position = user_info["work"].first["position"]["name"]
        user.job = "#{position} at #{employer}"
      end

      if user_info["education"].present?
        school = user_info["education"].last["school"]["name"]

        if user_info["education"].last["concentration"].present?
          concentration = user_info["education"].last["concentration"].first["name"]
          user.school = "Studied #{concentration} at #{school}"
        else
          user.school = "Studied at #{school}"
        end
      end

      if user.changed?
        user.save
      end



      friends = user.facebook.get_connections("me", "friends")
      friends.each do |friend|
        if SnsConnection.where(:uid => friend["id"], :provider => "facebook").blank?
          invited_user = user.has_invited.create :username => friend["name"], :email => "#{friend["id"]}@facebook.com", :status => User::USER_TYPE[:pending]
          sns_connection = invited_user.sns_connections.new :uid => friend["id"], :provider => "facebook"
          sns_connection.save(:validate => false)
        end
      end
    end
  end
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |sns_connection|
      sns_connection.provider = auth.provider
      sns_connection.uid = auth.uid
      if Rails.env != "test"
        sns_connection.oauth_token = auth.credentials.token
        sns_connection.oauth_expires_at = Time.at(auth.credentials.expires_at)
        sns_connection.url = auth.info.urls.send(auth.provider.capitalize)
      end
      sns_connection.save if sns_connection.attributes.present?
    end
  end
end
