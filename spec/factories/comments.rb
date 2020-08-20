FactoryBot.define do
  factory :comment do
    body { "MyComment" }
    user
    commentable { question }
    
    trait :invalid do
      body { nil }
    end
  end
end
