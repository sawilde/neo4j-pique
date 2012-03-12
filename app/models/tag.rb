class Tag < ActiveRecord::Base
  include Neoid::Node

  has_many :likes
  has_many :users, :through => :likes

  def to_neo
    neo_properties_to_hash(%w( name ))
  end

  def like_count
    likes.size
  end

  def is_liked_by(twitter_id)
    user = User.get_user_by_twitter_id(twitter_id)
    return false if user.nil?
    #ap user

    gremlin_query = <<-GREMLIN
      u = g.idx('users_index')[[ar_id:'#{user.id}']].next()
      u.out('likes').collect{it.ar_id}
    GREMLIN

    like_ids = Neoid.db.execute_script(gremlin_query)
    return like_ids.include? id
  end

  def list_friends_with_same_like(twitter_id)
    user = User.get_user_by_twitter_id(twitter_id)
    return [] if user.nil?

    cypher_query = "START user=node:users_index(ar_id={user_id}), tag=node:tags_index(ar_id={tag_id}) 
                    MATCH (user)-[:follows]->(friend)-[:likes]->(tag) 
                    RETURN friend.ar_id" 

    friend_ids = Neoid.db.execute_query(cypher_query, {:tag_id => self.id, :user_id => user.id})["data"]

    return User.where(:id => friend_ids.collect { |x| x[0]}).all.collect{ |u| u.screen_name }
  end

  class << self

    def get_tag_by_name(tag_name)
      Tag.where(:name => tag_name).first
    end

    def create_or_update_tag(tagdata)
    
      tag = Tag.get_tag_by_name(tagdata[:tag_name])
      
      if tag.nil?
        tag = Tag.new
        tag.name = tagdata[:tag_name]      
      end
          
      tag.save
      
      tag
    end

  end

end
