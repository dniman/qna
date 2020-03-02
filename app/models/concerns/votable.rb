module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
    
    scope :positive_votes, -> { votes.where("yes > ?", 0) }
    scope :negative_votes, -> { votes.where("yes = ?", 0) }
  end
end
