require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#mark_as_the_best_answer!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 2, user: user, question: question) }
    
    it "true" do
      answers[0].mark_as_the_best_answer!
      
      expect(answers[0]).to be_best_answer 
    end

    it "false" do
      answers[0].mark_as_the_best_answer!
      answers[1].mark_as_the_best_answer!
    
      answers[0].reload

      expect(answers[0]).not_to be_best_answer
    end

  end
end
