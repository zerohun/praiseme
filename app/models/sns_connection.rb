class SnsConnection < ActiveRecord::Base
  belongs_to :user

  after_save do |sns_connection|
    if sns_connection.user.present? && self.oauth_token.present?
      user = self.user

      user_info = user.facebook.get_object("me")

      if user_info["work"].present? 
        if user_info["work"].first["employer"].present?
          employer = user_info["work"].first["employer"]["name"]
        else
          employer = ""
        end

        if user_info["work"].first["position"].present?
          position = user_info["work"].first["position"]["name"]
        else
          position = "works"
        end
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
      user.delay.invites_friends_automatically if user.friends.blank?
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
