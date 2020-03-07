module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end
  
  def rating
    votes.sum('yes')
  end
end
