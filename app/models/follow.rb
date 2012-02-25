class Follow < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  
  include Neoid::Relationship
  neoidable start_node: :user, end_node: :friend, type: :follows
  
end
