require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #show" do
      get("/users/1").should route_to("users#show", :id => "1")
    end
    
    it "routes to #questions" do
      get("/users/1/questions").should route_to("users#questions", :id => "1")
    end
    
    it "routes to #answers" do
      get("/users/1/answers").should route_to("users#answers", :id => "1")
    end
      
    it "routes to #articles" do
      get("/users/1/articles").should route_to("users#articles", :id => "1")
    end
    
    it "routes to users#welcome" do
      get("/users/1/welcome").should route_to('users#welcome', :id => "1")
    end
    
    it "routes to #index" do
      get("/users").should route_to("users#index")
    end
  end
end
