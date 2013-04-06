class SnsConnection < ActiveRecord::Base
  belongs_to :user

  after_save do |sns_connection|
    if sns_connection.changed.include?('user_id') && sns_connection.user.present? && self.oauth_token.present?
      user = self.user
      friends = user.facebook.get_connections("me", "friends")
      friends.each do |friend|
        if SnsConnection.where(:uid => friend["id"], :provider => "facebook").blank?
          invited_user = user.has_invited.create :username => friend["name"], :email => "#{friend["id"]}@facebook.com"
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
