class User < ActiveRecord::Base
  include Neoid::Node

  has_many :follows
  has_many :friends, :through => :follows

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
        user = User.new(:twitter_id => userdata[:twitter_id])      
      end
      
      user.screen_name = userdata[:screen_name]
      user.profile_image_url = userdata[:profile_image_url]
    
      user.save
      
    end
  
    def refresh_friends(twitter_id, friend_ids)

      user = User.get_user_by_twitter_id(twitter_id)

      if user
      
        current_ids = user.friends.collect { |x| x.twitter_id }
        
        # keep the relationships up to date but only amongst users
        # who have accessed the application via twitter 

        # get those in friend_ids not in current_ids - add them
        new_friends = friend_ids
          .reject{ |e| current_ids.include? e }
          .collect{ |t| User.get_user_by_twitter_id(t) }
          .compact
                  
        user.friends += new_friends 
                
        user.save

        # get those in current_ids not in friend_ids - remove them        
        old_friends = current_ids
          .reject{ |e| friend_ids.include? e }
          .collect{ |t| User.get_user_by_twitter_id(t) }
          .compact

        for old_friend in old_friends
          user.follows.where(friend_id: old_friend.id, user_id: user.id).destroy_all
        end
      end
    end    
    
  end   

end
