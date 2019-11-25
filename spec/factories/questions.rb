FactoryBot.define do
  sequence :title do |n|
    "MyString #{n}"
  end
  
  factory :question do
    title
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end
    
    trait :with_files do
      after(:build) do |question|
        create(:question)
        question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
        question.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')
      end
    end
  end
end
