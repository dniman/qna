require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }


  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  
  describe '#user_question?' do
    it "should be true" do
      expect(user.user_question?(question)).to be_truthy
    end

    it "should be false" do
      expect(other_user.user_question?(question)).to be_falsy
    end
  end

  describe '#user_answer?' do
    let(:answer) { create(:answer, user: user, question: question) }

    it "should be true" do
      expect(user.user_answer?(answer)).to be_truthy
    end

    it "should be false" do
      other_answer = create(:answer, user: other_user, question: question)
      expect(user.user_answer?(other_user)).to be_falsy
    end
  end
end
