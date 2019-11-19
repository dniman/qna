require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#mark_as_the_best_answer!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 3, user: user, question: question) }
    
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

    describe 'default order' do
      it "should display the best answer first" do
        answers[2].mark_as_the_best_answer!
        question.reload

        expect(question.answers.first).to be_best_answer
      end
      
      it "should display other answers in ascending order" do
        answers[2].mark_as_the_best_answer!
        question.reload

        expect(question.answers.second).to eq(answers[0])
        expect(question.answers.last).to eq(answers[1])
      end
    end

  end
end
