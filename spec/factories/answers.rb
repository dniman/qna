FactoryBot.define do
  factory :answer do
    question 
    body { "MyText" }
    user
    
    trait :invalid do
      body { nil }
    end
    
    after(:build) do |answer|
      answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
      answer.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')
    end
  end
end
