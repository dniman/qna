class Services::Search
  attr_reader :search, :resource

  def initialize(search, resource)
    @search = search 
    @resource = resource
  end

  def call
    model_class.search(search) unless search.empty? 
  end

  private
    def model_class
      Object.const_get(resource.gsub('All', 'ThinkingSphinx').singularize)
    end
end
