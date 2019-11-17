require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }


  describe '#is_author?' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users[0]) }
    let(:answer) { create(:answer, question: question, user: users[0]) }
   
    it "should be true" do
      expect(users[0].is_author?(question)).to be
      expect(users[0].is_author?(answer)).to be
    end

    it "should be false" do
      expect(users[1].is_author?(question)).not_to be
      expect(users[1].is_author?(answer)).not_to be
    end
  end
end
