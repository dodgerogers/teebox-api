require "spec_helper"

describe SignedUrlsController do
  describe "routing" do

    it "routes to #index" do
      get("/signed_urls").should route_to("signed_urls#index")
    end
  end
end
