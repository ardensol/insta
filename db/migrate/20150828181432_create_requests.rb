class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.string :search_term

      t.timestamps null: false
    end
  end
end
