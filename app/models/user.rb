class User < ActiveRecord::Base
  include Neoid::Node

  has_many :follows
  has_many :friends, :through => :follows

  has_many :likes
  has_many :tags, :through => :likes

  def toggle_like(tag)
    if likes?(tag.id)
      unlike!(tag)
    else
      tags << tag
    end
  end

  def likes?(tag_id)
    likes.where(tag_id: tag_id).exists?
  end
  
  def like!(tag)
    tags << tag unless likes?(tag.id)
  end
  
  def unlike!(tag)
    likes.where(tag_id: tag.id, user_id: self.id).destroy_all
  end
  
  def to_neo
    neo_properties_to_hash(%w( twitter_id ))
  end

  class << self
    
    def get_user_by_twitter_id(twitter_id)
      User.where(:twitter_id => twitter_id).first
    end
    
    def create_or_update_user(userdata)
    
      user = User.get_user_by_twitter_id(userdata[:twitter_id])
      
      if user.nil?
        user = User.new( {:twitter_id => userdata[:twitter_id] })
      end
      
      user.screen_name = userdata[:screen_name]
      user.profile_image_url = userdata[:profile_image_url]
    
      user.save
      
      user
    end
  
    def refresh_friends(twitter_id, friend_ids)

      user = User.get_user_by_twitter_id(twitter_id)

      if user
      
        current_ids = user.friends.collect { |x| x.twitter_id }

        # keep the relationships up to date but only amongst users
        # who have accessed the application via twitter 

        # get those in friend_ids not in current_ids - add them
        new_friends = friend_ids
          .reject{ |e| current_ids.include? e.to_i }
          .collect{ |t| User.get_user_by_twitter_id(t.to_i) }
          .compact
        
        user.friends += new_friends 
                
        user.save
        

        # get those in current_ids not in friend_ids - remove them        
        old_friends = current_ids
          .reject{ |e| friend_ids.include? e.to_s }
          .collect{ |t| User.get_user_by_twitter_id(t) }
          .compact
 
        for old_friend in old_friends
          user.follows.where(friend_id: old_friend.id, user_id: user.id).destroy_all
        end
      end
    end    
    
  end   

end
