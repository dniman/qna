require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable).required }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  
  it { should allow_value('http://example.org').for(:url).ignoring_interference_by_writer }
  it { should_not allow_value('example.org').for(:url).ignoring_interference_by_writer }
  
  describe '#gist_url?' do
    it "should be true" do
      link = build(:link, :with_gist_url)

      expect(link).to be_gist_url
    end

    it "should be false" do
      link = build(:link)

      expect(link).not_to be_gist_url
    end
  end
end
