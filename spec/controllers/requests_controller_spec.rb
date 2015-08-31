require 'spec_helper'

RSpec.describe RequestsController, type: :controller do
  let(:request) { FactoryGirl.create(:request) }
  let(:influencer) {FactoryGirl.create(:influencer, request: request)}
  let(:user) {FactoryGirl.create(:user)}
  
  before { allow(controller).to receive(:current_user) { user } }

  describe "#index" do
  	it "successfully hits the index route" do
      controller.stub(:authenticate_user!)
      controller.stub(:verify_user)
      get :index, {}
  		expect(response).to be_success
  	end

  	it "shows the index page" do
      controller.stub(:authenticate_user!)
      controller.stub(:verify_user)
      get :index, {}
      expect(response).to render_template(:index)
    end
  end
end
