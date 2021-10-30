class SearchController < ApplicationController
  before_action :set_search, only: %w[index]

  def index
    @results = @search.run
  end

  private
    def set_search
      @search = Search.new(search_params)
    end

    def search_params
      params.permit(:search, :resource)
    end
end
