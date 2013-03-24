class CreateSnsConnections < ActiveRecord::Migration
  def change
    create_table :sns_connections do |t|
      t.string :provider
      t.string :uid
      t.string :oauth_token 
      t.datetime :oauth_expires_at

      t.string :url
      t.string :first_name
      t.string :last_name

      t.references :user
      t.timestamps
    end
    add_column :users, :username, :string
  end
end
