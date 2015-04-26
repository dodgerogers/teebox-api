module Teebox::Sociable
  def self.client
    Twitter::REST::Client.new do |config|
      config.consumer_key = CONFIG[:twitter_api_key]
      config.consumer_secret = CONFIG[:twitter_api_secret]
      config.access_token = CONFIG[:twitter_access_token]
      config.access_token_secret = CONFIG[:twitter_access_secret]
    end
  end
end