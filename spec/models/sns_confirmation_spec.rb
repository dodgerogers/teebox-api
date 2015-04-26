require "spec_helper"

describe SNSConfirmation do
  describe "confirm" do
    before(:each) do
      @topicArn = "arn:aws:sns:us-east-1:377092858912:Teebox_processing_DEV"
      @token = SecureRandom.hex
      @sns = double("Sns", confirm_subscription: "confirmed")
    end
    
    it "calls confirm_subscription" do
      AWS::SNS::Client.stub(:new).and_return(@sns)
      
      @sns.should_receive(:confirm_subscription).with(topic_arn: @topicArn, token: @token).and_return true
      SNSConfirmation.confirm(@topicArn, @token)
    end
  end
end