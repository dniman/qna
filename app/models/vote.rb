class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user
  
  scope :positive_votes, -> { where(yes: true) }
  scope :negative_votes, -> { where(yes: false) }
end
