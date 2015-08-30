class InstagramWorkerJob < ActiveJob::Base
  def perform(access_token, instagram_id, request)
    
    client = Instagram.client(access_token: access_token)

    #query instagram again for username information regarding user
    @user = client.user(instagram_id.to_i)


    influencer = Influencer.new
    

    influencer.request_id = request.id

    influencer.instagram_id = @user.id
    influencer.instagram_un = @user.username
    influencer.bio = @user.bio
    influencer.insta_website = @user.website
    influencer.followers = @user.counts.followed_by
    influencer.following = @user.counts.follows
    influencer.instagram_url = "http://instagram.com/#{@user.username}"
    influencer.instagram_img = @user.profile_picture
    # parse email
    email_parse(influencer)

    influencer.save
  end

  rescue_from(ActiveRecord::RecordNotUnique) do |exception|
   p "Record Not Unique, Skipped"
  end

  # parse emails of influencers

  def email_parse(influencer)
      r = Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)
      influencer.email = influencer.bio.scan(r)[0]
  end
end