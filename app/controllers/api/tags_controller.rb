class Api::TagsController < ApplicationController

  def toggle_like
    respond_to do |format|
      format.json do
        ap params
              
        render json: nil, status: :created
      end
    end
  end

  def view_likes
    respond_to do |format|
      format.json do
        ap params
              
        render json: {you: true, friends: ['fred', 'paul'], count: 0}, status: :created
      end
    end
  end

end
