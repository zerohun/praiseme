class SnsConnection < ActiveRecord::Base
  belongs_to :user
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
