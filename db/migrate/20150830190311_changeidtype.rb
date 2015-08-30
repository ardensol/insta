class Changeidtype < ActiveRecord::Migration
  def change
  	change_column :influencers, :instagram_id, :string
  end
end
