class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def get_domain
    port_str = request.port != 80 ? ":" + request.port.to_s : ""
    @hostname = "http://" + request.host + port_str 
  end

  def	get_twitter_api_key
    @twitter_api_key = ENV['TWITTER_API_KEY']
  end
  
end
