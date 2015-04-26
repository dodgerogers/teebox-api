require "spec_helper"

describe Teebox::Sociable do
  before(:each) do
     @client = Teebox::Sociable.client
   end
   
  describe "Teebox::Sociable.client" do
    it "creates twitter REST object" do
      @client.should be_a_kind_of(Twitter::REST::Client)
    end
  
    it "returns correct API key" do
      @client.consumer_key.should eq CONFIG[:twitter_api_key]
    end
  
    it "returns correct API secret" do
      @client.consumer_secret.should eq CONFIG[:twitter_api_secret]
    end
  
    it "returns correct API access token" do
      @client.access_token.should eq CONFIG[:twitter_access_token]
    end
  
    it "returns correct API access secret" do
      @client.access_token_secret.should eq CONFIG[:twitter_access_secret]
    end
  end
end