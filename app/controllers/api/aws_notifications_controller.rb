require "json"

module Api
  class AwsNotificationsController < ApplicationController
    skip_before_action :authenticate_user!
    
    def end_point
      notification = JSON.parse(request.raw_post, symbolize_names: true)
    
      if notification[:Type] == "SubscriptionConfirmation"
        SNSConfirmation.confirm(notification[:TopicArn], notification[:Token])
      elsif notification[:Type] == "Notification"
        payload_hash = AwsVideoPayloadRepository.retrieve_payload(notification)
        VideoRepository.find_by_job_and_update(payload_hash) if payload_hash
      end
      logger.info(notification)
      render nothing: true
    end
  end
end