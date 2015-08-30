class RequestsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :verify_user, only: [:show, :edit, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    @requests = current_user.requests.order('id DESC').all
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        format.html { redirect_to root_path, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to root_path, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ##Search Tags 

  def search_tag

    #create Request
    request = Request.new
    request.user_id = current_user.id
    request.search_term = params[:search_term]
    request.save
    
    client = Instagram.client(access_token: session[:access_token])
    
    @recent_tags = client.tag_recent_media(params[:search_term])
    
    @recent_tags.each do |tag|
      
      #get instagram id from caption of picture
      @id = tag.caption.from.id

      #query instagram again for username information regarding user

      @user = client.user(@id)

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
    flash[:notice] = "Your Search is Being Processed..."
    redirect_to requests_path
  end

  # parse emails of influencers

  def email_parse(influencer)
      r = Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)
      influencer.email = influencer.bio.scan(r)[0]
  end

  private

    # Use callbacks to share common setup or constraints between actions.

    def set_request
      @request = Request.find(params[:id])
    end

    def verify_user
      if current_user.id != @request.user_id
        redirect_to root_path
        flash[:error] = "You're Not Authorized to View That Page" 
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:user_id, :search_term)
    end
end
  