class CreateInfluencers < ActiveRecord::Migration
  def change
    create_table :influencers do |t|
      t.string :instagram_url
      t.string :instagram_un
      t.integer :followers
      t.integer :following
      t.string :bio
      t.string :insta_website
      t.string :email
      t.string :location
      t.integer :age
      t.string :gender
      t.string :twitter_url
      t.string :facebook_url
      t.string :linkedin_url

      t.timestamps null: false
    end
  end
end
