require "spec_helper"

describe Devise::SessionsController do
  it "routes to #new" do
    get('/users/login').should route_to('devise/sessions#new')
  end
  
  it "routes to #create" do
    post("users/login").should route_to('devise/sessions#create')
  end
  
  it "routes to #destroy" do
    delete('users/logout').should route_to('devise/sessions#destroy')
  end
end  