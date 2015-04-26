require "spec_helper"

describe ActivitiesController do

    it "routes to #index" do
      get("/activities").should route_to("activities#index")
    end

    it "routes to #notifications" do
      get("/activities/notifications").should route_to("activities#notifications")
    end

    it "routes to #read" do
      get("/activities/1/read").should route_to("activities#read", id: "1")
    end
end
