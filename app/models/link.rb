class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true
  validates_format_of :url, with: URI.regexp(['http', 'https'])
end
