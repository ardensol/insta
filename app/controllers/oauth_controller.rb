class OauthController < ApplicationController

  def connect
    redirect_to Instagram.authorize_url(redirect_uri: ENV['INSTA_REDIRECT'])
  end

  def callback
    response = Instagram.get_access_token(params[:code], redirect_uri: ENV['INSTA_REDIRECT'])
    session[:access_token] = response.access_token
    redirect_to root_path
  end

end