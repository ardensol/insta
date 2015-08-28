require 'instagram'
##Configuring Instagram Client with ENV Variables

Instagram.configure do |config|
	config.client_id = ENV['INSTA_CLIENT']
	config.client_secret = ENV['INSTA_SECRET']
end