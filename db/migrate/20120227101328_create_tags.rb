class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
    
    add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  end
end
