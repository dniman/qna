FactoryBot.define do
  factory :subscription do
    user
    question { nil }
  end
end
