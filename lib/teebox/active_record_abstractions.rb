module Teebox
  module ActiveRecordAbstractions
    
    def save(record)
      before_save record
      record.save
    end
    
    def before_save(record)
    end

    def destroy(record)
      record.destroy
    end

    def where(records, attrs)
      query = records.where attrs
      query
    end
    
    def where_not(records, attrs)
      query = records.where.not attrs
      query
    end
    
    def order(records, attrs)
      query = records.order attrs
      query
    end
    
    def error_messages(record)
      record.errors.full_messages
    end
  end
end
