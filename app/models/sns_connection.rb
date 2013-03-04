class SnsConnection < ActiveRecord::Base
  belongs_to :user
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |sns_connection|
      sns_connection.provider = auth.provider
      sns_connection.uid = auth.uid
    end
  end
end
