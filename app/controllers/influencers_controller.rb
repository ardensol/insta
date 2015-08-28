class InfluencersController < ApplicationController
  before_action :set_influencer, only: [:show, :edit, :update, :destroy, :fullcontact]
  
  # GET /influencers
  # GET /influencers.json
  def index
    @influencers = Influencer.all
  end

  # GET /influencers/1
  # GET /influencers/1.json
  def show
  end

  # GET /influencers/new
  def new
    @influencer = Influencer.new
  end

  # GET /influencers/1/edit
  def edit
  end

  # POST /influencers
  # POST /influencers.json
  def create
    @influencer = Influencer.new(influencer_params)

    respond_to do |format|
      if @influencer.save
        format.html { redirect_to root_path, notice: 'Influencer was successfully created.' }
        format.json { render :show, status: :created, location: @influencer }
      else
        format.html { render :new }
        format.json { render json: @influencer.errors, status: :unprocessable_entity }
      end
    end
  end

  def fullcontact
    
    # Call Full Contact
    fullcontact_details = FullContact.person(email: @influencer.email)

    #Insert Hashie Mash Data
    
    @influencer.first_name = fullcontact_details.contact_info.given_name
    @influencer.last_name = fullcontact_details.contact_info.family_name
    @influencer.location = fullcontact_details.demographics.location_deduced.deduced_location
    @influencer.gender = fullcontact_details.demographics.gender
    @influencer.age = fullcontact_details.demographics.age

    ## Turn Hashie Mash Social Profiles into JSON Hash So I can Find By Type

    social_array = fullcontact_details.social_profiles.as_json

    ## Search JSON for Facebook, Linkedin and Twitter Types

    if facebook = social_array.find { |h| h['type'] == 'facebook'}
      @influencer.facebook_url = facebook['url']
    end

    if linkedin = social_array.find { |h| h['type'] == 'linkedin'}
      @influencer.linkedin_url = linkedin['url']
    end  

    if twitter = social_array.find { |h| h['type'] == 'twitter'}
      @influencer.twitter_url = twitter['url']
    end  
  

    @influencer.save

    redirect_to influencers_url
    
  end


  # PATCH/PUT /influencers/1
  # PATCH/PUT /influencers/1.json
  def update
    respond_to do |format|
      if @influencer.update(influencer_params)
        format.html { redirect_to root_path, notice: 'Influencer was successfully updated.' }
        format.json { render :show, status: :ok, location: @influencer }
      else
        format.html { render :edit }
        format.json { render json: @influencer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /influencers/1
  # DELETE /influencers/1.json
  def destroy
    @influencer.destroy
    respond_to do |format|
      format.html { redirect_to influencers_url, notice: 'Influencer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_influencer
      @influencer = Influencer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def influencer_params
      params.require(:influencer).permit(:instagram_url, :instagram_un, :followers, :following, :bio, :insta_website, :email, :location, :age, :gender, :twitter_url, :facebook_url, :linkedin_url)
    end
end
