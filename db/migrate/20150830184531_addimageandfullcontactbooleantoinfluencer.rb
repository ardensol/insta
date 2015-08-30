class Addimageandfullcontactbooleantoinfluencer < ActiveRecord::Migration
  def change
  	add_column :influencers, :instagram_img, :string
  	add_column :influencers, :fullcontact_checked, :boolean
  end
end
