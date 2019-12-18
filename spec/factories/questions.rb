require 'securerandom'

FactoryBot.define do
  sequence :title do |n|
    "MyString #{n}"
  end
  
  factory :question do
    title
    body { "MyText" }
    user
   
    trait :with_bounty do
      after(:build) do |question|
        question.bounty = FactoryBot.build(:bounty)
      end
    end

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

    trait :with_links do
      after(:create) do |question|
        create_list(:link, 2, linkable: question)
      end
    end

    trait :with_gists do
      after(:create) do |question|
        create(:link, linkable: question, url: "https://gist.github.com/#{SecureRandom.uuid.split('-').join('')}")
        create(:link, linkable: question, url: "https://gist.github.com/#{SecureRandom.uuid.split('-').join('')}")
      end
    end
  end
end
