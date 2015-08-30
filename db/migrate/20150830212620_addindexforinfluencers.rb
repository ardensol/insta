class Addindexforinfluencers < ActiveRecord::Migration
  def change
  	add_index :influencers, [:instagram_id, :request_id], unique: true
  end
end
