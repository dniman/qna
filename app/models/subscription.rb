class Subscription < ApplicationRecord
  belongs_to :subscriptionable, polymorphic: true
  belongs_to :user
end
