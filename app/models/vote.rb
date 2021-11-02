class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user
end
