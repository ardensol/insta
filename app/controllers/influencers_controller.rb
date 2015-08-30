class InfluencersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_influencer, only: [:show, :edit, :update, :destroy, :fullcontact]
  before_action :set_request, only: [:show, :edit, :update, :destroy]  
  before_action :verify_user, only: [:show, :edit, :update, :destroy]
  # GET /influencers
  # GET /influencers.json
  def index
    if params[:request_id]
      request = Request.find(params[:request_id])
      @influencers = request.influencers.page(params[:page]).per(50)
    else
      @influencers = current_user.influencers.page(params[:page]).per(50)
    end
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
      
    begin
      # Call Full Contact Details as JSON
      fullcontact_details = FullContact.person(email: @influencer.email).as_json

      #If key does not exist, set value equal to empty string

      @influencer.first_name = fullcontact_details.fetch('contact_info', {}).fetch('given_name', '')

      @influencer.last_name = fullcontact_details.fetch('contact_info',{}).fetch('family_name', '')

      @influencer.location = fullcontact_details.fetch('demographics', {}).fetch('location_deduced', {}).fetch('deduced_location', '')

      @influencer.gender = fullcontact_details.fetch('demographics', {}).fetch('gender', '')

      @influencer.age = fullcontact_details.fetch('demographics', {}).fetch('age', '')


      # Find Social Array So socialnetwork can Find By Type
      social_array = fullcontact_details.fetch('social_profiles', {})


      if facebook = social_array.find { |h| h['type'] == 'facebook'}
        @influencer.facebook_url = facebook['url']
      end

      if linkedin = social_array.find { |h| h['type'] == 'linkedin'}
        @influencer.linkedin_url = linkedin['url']
      end  

      if twitter = social_array.find { |h| h['type'] == 'twitter'}
        @influencer.twitter_url = twitter['url']
      end  
      
      
    rescue FullContact::NotFound
      flash[:error] = "Email Not Found in Database" 
    rescue FullContact::Invalid
      flash[:error] = "Email is Invalid"
    rescue => e
      flash[:error] = e.message
    end
    
    @influencer.fullcontact_checked = true
    @influencer.save
    redirect_to(:back)
    
  end


  # PATCH/PUT /influencers/1
  # PATCH/PUT /influencers/1.json
  def update
    respond_to do |format|
      if @influencer.update(influencer_params)
        format.html { redirect_to :back, notice: 'Influencer was successfully updated.' }
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

    def set_request
      @request = Request.find(params[:request_id])
    end

    def verify_user
      if current_user.id != @request.user_id
        redirect_to root_path
        flash[:error] = "You're Not Authorized to View That Page" 
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def influencer_params
      params.require(:influencer).permit(:instagram_url, :instagram_un, :followers, :following, :bio, :insta_website, :email, :location, :age, :gender, :twitter_url, :facebook_url, :linkedin_url, :instagram_img, :fullcontact_checked, :instagram_id)
    end
end
