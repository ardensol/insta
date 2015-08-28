class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :insta_authorized?

  def insta_authorized?
  	if session[:access_token] != nil
  		true
  	else
  		false
  	end
  end


end
