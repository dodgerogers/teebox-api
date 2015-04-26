class ReportRepository < BaseRepository
  ERROR_MSG_GENERIC = "ReportRepository error: %s"
  ACCEPTABLE_MODELS = ["question", "answer", "user"]
  IGNORED_KEYS = ['id', 'created_at', 'updated_at']
  
  def self.generate(report)
    raise ArgumentError, sprintf(ERROR_MSG_GENERIC, "must supply a valid report object") unless report.is_a?(Report)
    
    if report 
      latest_report = Report.last
      latest_report_values = latest_report.attributes.except(*IGNORED_KEYS) if latest_report
    
      report.class.transaction do
        ACCEPTABLE_MODELS.each do |object|
          report.send("#{object.pluralize}"+ "=", self.record_query(object))
          report.send("#{object.pluralize}_total" + "=", object.classify.constantize.all.size)
        end
      end
      
      unless report.attributes.except(*IGNORED_KEYS) == latest_report_values
        return report.save!
      else
        return false
      end
    end
  end
  
  private 
  
  def self.record_query(object)
    object.classify.constantize.where("created_at > ?", 1.day.ago).size
  end
end