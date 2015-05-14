module Teebox
  module Repository
    extend ActiveSupport::Concern

    SEARCH_BY_METHOD_NAME = "search_by"
    FIND_BY_METHOD_NAME = "find_by"
    METHOD_NAME_DELIMITER = "_and_"
    METHOD_NOT_DEFINED = "%s is not defined for %s."
    IGNORED_KEYS = [:page, :per_page, :user_token, :user_email]

    attr_accessor :collection, :entity, :errors, :failure

    def success?
      !failure
    end

    def fail(message=nil)
      self.failure = true
      self.errors = message
      return self
    end

    def search_by(params)
      dynamic_finder_method SEARCH_BY_METHOD_NAME, params
    end
    
    def find_by(params)
      dynamic_finder_method FIND_BY_METHOD_NAME, params
    end
    
    module ClassMethods
      def declare(klass)
        self.class_eval do
          method_name = klass.to_s.demodulize.tableize.singularize
          define_method method_name do
            klass
          end
        end
      end
    end
    
    private 
    
    def params_to_method(method_name, params)
      raise ArgumentError unless params.is_a? Hash || params.nil?
      
      sanitized_params = params.except *IGNORED_KEYS
      methodized_params = sanitized_params.keys.sort.join METHOD_NAME_DELIMITER

      "#{method_name}_#{methodized_params}".to_sym
    end
    
    def dynamic_finder_method(method_name, params)
      finder_method = params_to_method method_name, params
      if self.respond_to? finder_method, true
        self.send finder_method, params
      else
        self.fail message: METHOD_NOT_DEFINED % [finder_method, self.class]
      end
    end
  end
end