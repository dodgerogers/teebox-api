class GlobalSearch
  include Interactor
  
  STANDARD_ERR = 'GlobalError: %s'
  NOT_IMPLEMENTED_ERR = "#search not implemented for %s"
  SEARCH_PARAMS_ERROR = 'query must be a string'
  
  SEARCHABLE = [:questions, :users, :articles]
  PAGE_PARAMS = SEARCHABLE.map {|model| "#{model}_page".to_sym }
  TOTAL_ENTRIES = 100
  PER_PAGE = 6
  
  def call  
    unless context[:search].is_a?(String)
      context.fail!(message: sprintf(STANDARD_ERR, SEARCH_PARAMS_ERROR))
    end
    
    context.collection = {}
    context.total = 0
    
    SEARCHABLE.each do |model|
      klass = model.to_s.singularize.titleize
      klass_const = klass.constantize
      page_param = "#{model}_page".to_sym
      
      if klass_const.respond_to?(:search)
        query = klass_const.search(context[:search])
        query = query.search_conditions if klass_const.respond_to?(:search_conditions)
        
        context.collection[model] = query.paginate(page: context[page_param], per_page: PER_PAGE) 
      else
        context.fail!(message: sprintf(NOT_IMPLEMENTED_ERR, klass))
      end
    end
    context.total = context.collection.values.map(&:length).reduce(:+)
  end
end