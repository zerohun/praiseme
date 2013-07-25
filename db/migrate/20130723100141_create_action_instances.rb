class CreateActionInstances < ActiveRecord::Migration
  def change
    create_table :action_instances do |t|
      t.string :instance_id
      t.string :content_type
      t.references :content, index: true
      t.timestamps
    end
  end
end
