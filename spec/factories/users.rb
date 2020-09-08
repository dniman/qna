FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email 
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { DateTime.now }
  end
  
  factory :unconfirmed_user, class: User do
    email 
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { nil }
    
    trait :invalid do
      email { nil }
    end
  end
end

