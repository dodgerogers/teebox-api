require "spec_helper"

describe PointsController do
  it "routes to users/:id/points" do
    get("users/1/points").should route_to('points#index', id: "1")
  end
  
  it "routes to users/:id/breakdown" do
    get("users/1/breakdown").should route_to('points#breakdown', id: '1')
  end
end