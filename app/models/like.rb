class Like < ActiveRecord::Base

  belongs_to :user
  belongs_to :tag
  
  include Neoid::Relationship
  neoidable start_node: :user, end_node: :tag, type: :likes

end
