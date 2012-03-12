class Api::TagsController < ApplicationController

  def toggle_like
    respond_to do |format|
      format.json do
        tag = Tag.create_or_update_tag({:tag_name => params[:tag_name]})
        user = User.get_user_by_twitter_id(params[:twitter_id])

        user.toggle_like(tag) unless user.nil?
        user.save
              
        data = get_tag_like_data(params) 
        render json: data, status: :ok
      end
    end
  end

  def view_likes
    respond_to do |format|
      format.json do
         data = get_tag_like_data(params) 
         render json: data, status: :ok
      end
    end
  end

  def get_tag_like_data(params)
    tag = Tag.create_or_update_tag({:tag_name => params[:tag_name]})
    friends = tag.list_friends_with_same_like(params[:twitter_id])
    liked = tag.is_liked_by(params[:twitter_id])
    count = tag.like_count     
    # #ap tag 
    {you: liked, friends: friends, count: count}
  end

end
