require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }


  describe '#author_of?' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users[0]) }
    let(:answer) { create(:answer, question: question, user: users[0]) }
  
    it "should be true" do
      expect(users[0]).to be_author_of(question)
      expect(users[0]).to be_author_of(answer)
    end

    it "should be false" do
      expect(users[1]).not_to be_author_of(question)
      expect(users[1]).not_to be_author_of(answer)
    end
  end
end
