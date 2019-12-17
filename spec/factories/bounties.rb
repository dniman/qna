FactoryBot.define do
  factory :bounty do
    name { "MyBounty" }
    question
    user { nil }

    trait :with_image do
      after(:build) do |bounty|
        bounty.image.attach(io: File.open(Rails.root.join('spec/fixtures/sample_files', 'bounty.png')), filename: 'bounty.png', content_type: 'image/png')
      end
    end
  end
end
