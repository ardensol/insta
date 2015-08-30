class Addinstagramid < ActiveRecord::Migration
  def change
  	add_column :influencers, :instagram_id, :integer
  end
end
