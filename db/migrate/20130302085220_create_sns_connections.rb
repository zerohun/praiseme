class CreateSnsConnections < ActiveRecord::Migration
  def change
    create_table :sns_connections do |t|
      t.string :provider
      t.string :uid
      t.references :user
      t.timestamps
    end
    add_column :users, :username, :string
  end
end
