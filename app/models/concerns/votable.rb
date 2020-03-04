module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end
  
  def rating
    votes.inject(0){ |sum, rec| sum += (rec['yes'] && 1 || -1) ; sum }
  end
end
