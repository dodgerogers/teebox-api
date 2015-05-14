class ActivityRepository < BaseRepository
  
  def initialize(instance)
    @instance = instance
  end
  
  # FACTORY
  def generate(action, opts={})
    owner, recipient = opts.values_at(:owner, :recipient)
    raise ArgumentError, 'You must provide an instance object' unless @instance
    
    if owner != recipient
      attributes = { 
        key: "#{@instance.class.to_s.downcase}.#{action}", 
        owner: owner, 
        recipient: recipient
      }
      activity = @instance.activities.build attributes
      #activity.html = ApplicationController.helpers.generate_activity_html activity, @instance
      activity.save
    end
  end
end