require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#mark_as_the_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 2, user: user, question: question) }
    
    it "changes is_best to true" do
      answers[0].mark_as_the_best!
      
      expect(answers[0].is_best?).to be
    end

    it "changes other's is_best to false" do
      answers[0].mark_as_the_best!
      answers[1].mark_as_the_best!
    
      answers[0].reload

      expect(answers[0].is_best?).not_to be
    end

  end
end
