class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :tag_id

      t.timestamps
    end
    
    add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  end
end
