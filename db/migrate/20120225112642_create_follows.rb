class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id, :limit => 8
      t.integer :friend_id, :limit => 8

      t.timestamps
    end
    
    add_index "follows", ["user_id"], :name => "index_follows_on_user_id"

  end
end
