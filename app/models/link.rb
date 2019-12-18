class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI.regexp(['http', 'https'])

  def gist_url?
    self.url.match?(/gist.github.com/)
  end
end
