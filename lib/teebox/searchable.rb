module Teebox::Searchable
  extend ActiveSupport::Concern
  include PgSearch
  
  module ClassMethods
    def searchable(*fields)
      default_opts = { tsearch: { prefix: true, dictionary: "english", any_word: true } }
      pg_search_scope(:search, against: fields, using: default_opts)
    end
    
    def search(query)
      if query.present?
        search(sanitize(query))
      else
        all
      end
    end
  end
end