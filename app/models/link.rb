class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, required: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI.regexp(['http', 'https'])

  default_scope { order(id: :desc).order(:created_at) }

  def gist_url?
    self.url.match?(/gist.github.com/)
  end
end
