class Api::UsersController < ApplicationController
  
  def register
    respond_to do |format|
      format.json do
        #ap params

        User.create_or_update_user({
          :twitter_id => params[:twitter_id], 
          :screen_name => params[:screen_name], 
          :profile_image_url => params[:profile_image_url]})
              
        render json: nil, status: :created
      end
    end
  end
  
  def update_friends
    respond_to do |format|
      format.json do
        #ap params

        User.refresh_friends(params[:twitter_id], params[:friend_ids]) 
        
        render json: nil, status: :created
      end
    end
  end
  
end
