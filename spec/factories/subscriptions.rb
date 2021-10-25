FactoryBot.define do
  factory :subscription do
    user
    subscriptionable { nil }
  end
end
