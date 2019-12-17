require 'rails_helper'

RSpec.describe Bounty, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :name }

  it 'has one attached image' do
    expect(subject.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
