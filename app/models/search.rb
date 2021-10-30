class Search
  include ActiveModel::Model

  attr_accessor :search, :resource

  validates :resource, presence: true

  def run
    Services::Search.new(search, resource).call
  end
end
