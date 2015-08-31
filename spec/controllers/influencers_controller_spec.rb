require 'spec_helper'

RSpec.describe InfluencersController, type: :controller do
  let(:request) { FactoryGirl.create(:request) }
  let(:influencer) {FactoryGirl.create(:influencer, request: request)}
    
  describe "#index" do
  	it "successfully hits the index route" do
      controller.stub(:authenticate_user!)
      get :index, request_id: influencer.request_id
  		expect(response).to be_success
  	end

  	it "shows the index page" do
      controller.stub(:authenticate_user!)
      controller.stub(:verify_user)
      get :index, request_id: influencer.request_id 
      expect(response).to render_template(:index)
    end
  end

    describe "#show" do
	    it "successfully hits the show route" do
        controller.stub(:authenticate_user!)
        controller.stub(:verify_user)
	      get :show, id: influencer.id, request_id: influencer.request_id
	      expect(response).to be_success
	    end

	    it "shows the influencer page" do
        controller.stub(:authenticate_user!)
        controller.stub(:verify_user)
	      get :show, request_id: influencer.request_id, id: influencer.id
	      expect(response).to render_template(:show)
	    end
	end
end
