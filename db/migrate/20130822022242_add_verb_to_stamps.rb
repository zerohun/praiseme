class AddVerbToStamps < ActiveRecord::Migration
  def change
    add_column :stamps, :verb, :integer, :default => 0
  end
end
