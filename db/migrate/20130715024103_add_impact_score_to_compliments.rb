class AddImpactScoreToCompliments < ActiveRecord::Migration
  def change
    add_column :compliments, :impact_score, :integer
  end
end
