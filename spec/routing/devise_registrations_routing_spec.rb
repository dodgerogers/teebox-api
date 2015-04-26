require "spec_helper"

describe Devise::RegistrationsController do
  it "routes to #create" do
    post("/users").should route_to("devise/registrations#create")
  end
  
  it "routes to registrations #cancel" do
    get('/users/cancel').should route_to("devise/registrations#cancel")
  end
    
  it "routes to #new" do
    get('/users/sign_up').should route_to("devise/registrations#new")
  end
  
  it "routes to #edit" do
    get('/users/edit').should route_to("devise/registrations#edit")
  end
  
  it "routes to #update" do
    put("/users").should route_to('devise/registrations#update')
  end
  
  it "routes to #destroy" do
    delete('/users').should route_to('devise/registrations#destroy')
  end
end