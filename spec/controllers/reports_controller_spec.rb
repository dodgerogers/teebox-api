require "spec_helper"

describe Api::ReportsController do
  before(:each) do
    @user1 = create(:user)
    @user1.confirm!
    @report = create(:report)
    @params = { 
      user_token: @user1.authentication_token, 
      user_email: @user1.email, 
    }
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index, @params
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'reports'
    end
  end
  
  describe "POST create" do
    context "success" do
      it "returns 200 and report" do
        post :create, @params
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'report'  
      end
    end
    
    context "failure" do
      it "returns 422 and errors" do
        ReportRepository.should_receive(:generate).and_return(false)
        
        post :create, @params
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
  
  describe "DELETE destroy" do    
    context "success" do
      it 'returns 200' do
        delete :destroy, @params.merge(id: @report.id)
        
        response.status.should eq 200
      end
    end

    context 'failure' do
      it "returns 422 and errors" do
        Report.any_instance.stub(:destroy).and_return false
        
        delete :destroy, @params.merge(id: @report.id)
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
end