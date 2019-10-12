FactoryBot.define do
  factory :answer do
    question 
    body { "MyText" }
    user
    
    trait :invalid do
      body { nil }
    end
  end
end
