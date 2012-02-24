class MainController < ApplicationController
  
  before_filter :get_domain, :get_twitter_api_key

  def index
  end
  
end
