class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :twitter_id, :limit => 8
      t.string :screen_name
      t.string :profile_image_url

      t.timestamps
    end
    
    add_index "users", ["twitter_id"], :name => "index_users_on_twitter_id", :unique => true

  end
end
