class SNSConfirmation
  def self.confirm(arn, token)
    sns = AWS::SNS::Client.new
    sns.confirm_subscription(topic_arn: arn, token: token)
  end
end