FactoryBot.define do
  sequence :name do |n|
    "MyString #{n}"
  end

  sequence :url do |n|
    "http://example#{n}.org"
  end

  factory :link do
    name 
    url 

    trait :with_gist_url do
      url { 'https://gist.github.com/' }
    end
  end
end
