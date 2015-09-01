class RequestsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :verify_user, only: [:show, :edit, :update, :destroy]

  # GET /requests
  # GET /requests.json
  def index
    @requests = current_user.requests.order('id DESC').all
  end

  # GET /requests/new
  def new
    @request = Request.new
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
    
    if request.save
      client = Instagram.client(access_token: session[:access_token])

      next_id = nil
      pages = 0

      while pages < 5 do

        @recent_tags = client.tag_recent_media(request.search_term, max_id: next_id)
        
        @recent_tags.each do |tag|
          
            #get instagram id from caption of picture
            @id = tag.caption.from.id

            InstagramWorkerJob.perform_later(session[:access_token], @id, request)
        end

        next_id = @recent_tags.pagination.next_max_id

        pages += 1

      end
      flash[:notice] = "Your Search is Being Processed..."
      redirect_to requests_path
    else
      flash[:error] = "Your Request is Invalid.  Please Don't Use a Hashtag, Symbols or Spaces"
      redirect_to requests_path
    end
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
  