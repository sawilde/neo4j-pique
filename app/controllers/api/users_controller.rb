class Api::UsersController < ApplicationController
  
  def register
    respond_to do |format|
    format.json do
      data = { :update_friends => true }
      render json: data, status: :created
      end
    end
  end
  
  def update_friends
    respond_to do |format|
    format.json do
      data = { :update_friends => false }
      render json: data, status: :created
      end
    end
  end
  
end
