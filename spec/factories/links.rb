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
  end
end
