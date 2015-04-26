require "spec_helper"

describe ConfirmationsController do
  
  before(:each) do
    @user = create(:user)
  end

  describe "after_confirmation_path_for" do
    it "redirects_to welcome_path" do
      controller.after_confirmation_path_for(User, @user).should eq welcome_path(@user.id)
    end
  end
end