class Addrequestidtoinfluencers < ActiveRecord::Migration
  def change
  	add_column :influencers, :request_id, :integer
  end
end
