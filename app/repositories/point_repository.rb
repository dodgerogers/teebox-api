class PointRepository < BaseRepository
  ERROR_MSG_GENERIC = "PointRepository error: %s"
  HASH_ARG_ERROR = "Args must be a Hash"
  VALUE_INT_ERROR = "Value must be an integer"
  
  def self.create(user, entry, points=0)
    user.points.build(value: points, pointable_id: entry.id, pointable_type: entry.class.name.capitalize).save
  end
  
  def self.mass_update(*arguments)
    updated = arguments.each.map {|attrs| self.find_and_update(attrs) }
    return updated.include?(false) ? false : true
  end
  
  def self.find_and_update(attributes)
    raise ArgumentError, sprintf(ERROR_MSG_GENERIC, HASH_ARG_ERROR) unless attributes.is_a?(Hash)
    raise ArgumentError, sprintf(ERROR_MSG_GENERIC, VALUE_INT_ERROR) unless attributes[:value].is_a?(Integer)
    entry, value = attributes.values_at(:entry, :value)
    
    self.create(entry.user, entry) unless entry.point
    
    point = self.klass.where(pointable_id: entry.id, pointable_type: entry.class.to_s).first 
    point.update_attributes(value: value)
  end
  
  private
  
  def self.klass
    Point
  end
end