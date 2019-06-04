FactoryBot.define do
  factory :answer do
    question 
    body { "MyText" }
    
    trait :invalid do
      body { nil }
    end
  end
end
