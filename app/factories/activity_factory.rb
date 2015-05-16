class ActivityFactory < BaseFactory
  
  NOT_IMPLEMENTED = "%s does not implement activties"
  MISSING_PARAMS = "Missing owner or recipient params: %s %s"
  
  def initialize(record)
    @record = record
  end
  
  def generate(action, params={})
    owner, recipient = params.values_at(:owner, :recipient)
    
    unless owner || recipient
      raise ArgumentError, MISSING_PARAMS % [owner, recipient]
    end
    
    if owner != recipient
      action_key = "#{@record.class.to_s.downcase}.#{action}",
      attributes = { key: action_key, owner: owner, recipient: recipient }
      
      # TODO: Build HTML
      activity = @record.activities.build attributes
      save activity
    end
  end
  
  private
  
  def generate_activity_string(activity); end
  def sanitize_attributes(params); end
end