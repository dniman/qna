require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples 'linkable'
  include_examples 'votable'
  include_examples 'commentable'

  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:bounty).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :bounty }

  it 'has one or many attached files' do
    expect(subject.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
