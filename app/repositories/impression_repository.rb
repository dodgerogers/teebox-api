class ImpressionRepository < BaseRepository
  ERROR_MSG_GENERIC = "ImpressionRepository error: %s"
  IMPRESSIONS_NOT_IMPLEMENTED = '#impressions relationship not implemented'
  
  def self.create(record, request)
    raise ArgumentError unless request && request.remote_ip
    
    if record.respond_to?(:impressions)
      impression = record.impressions.build(ip_address: request.remote_ip)
      if impression.save
        Rails.logger.debug("#{impression.attributes} Created\n")
      else
        Rails.logger.debug(sprintf(ERROR_MSG_GENERIC, impression.errors.full_messages))
      end
    else
      raise NotImplementedError, sprintf(ERROR_MSG_GENERIC, IMPRESSIONS_NOT_IMPLEMENTED)
    end
  end
end