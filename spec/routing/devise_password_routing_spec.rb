require "spec_helper"

describe Devise::PasswordsController do
  it "routes to #new" do
    get('/users/password/new').should route_to('devise/passwords#new')
  end
  
  it "routes to #create" do
    post("/users/password").should route_to('devise/passwords#create')
  end
  
  it "routes to #edit" do
    get('users/password/edit').should route_to('devise/passwords#edit')
  end
  
  it "routes to #update" do
    put('users/password').should route_to('devise/passwords#update')
  end
end