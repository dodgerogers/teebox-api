class ArticleRepository < BaseRepository
  ARTICLE_ERR_MSG = 'You must supply a valid Article object'
  
  def self.transition(article, method)
    raise ArgumentError, ARTICLE_ERR_MSG unless article.is_a?(Article)
    
    success = article.send(method)
    message = (success ? 'successful' : 'failed')
    
    return success, "Article transition to #{article.state} #{message}"
  end
end