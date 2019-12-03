FactoryBot.define do
  factory :answer do
    question 
    body { "MyText" }
    user
    
    trait :invalid do
      body { nil }
    end
    
    trait :with_files do
      after(:build) do |answer|
        answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
        answer.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')
      end
    end
    
    trait :with_links do
      after(:create) do |answer|
        create_list(:link, 2, linkable: answer)
      end
    end
    
    trait :with_gists do
      after(:create) do |answer|
        create(:link, linkable: answer, url: "https://gist.github.com/#{SecureRandom.uuid.split('-').join('')}")
        create(:link, linkable: answer, url: "https://gist.github.com/#{SecureRandom.uuid.split('-').join('')}")
      end
    end
  end
end
