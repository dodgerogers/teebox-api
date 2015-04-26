require "spec_helper"

describe Devise::ConfirmationsController do
  it "routes to #create" do
    post("/users/confirmation").should route_to("confirmations#create")
  end
  
  it "routes to #new" do
    get("/users/confirmation/new").should route_to("confirmations#new")
  end
  
  it "routes to #new" do
    get("/users/confirmation").should route_to("confirmations#show")
  end
end