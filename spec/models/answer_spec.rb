require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  
  context 'methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 2, question: question) }
    
    describe '#mark_as_the_best_answer!' do
      it "true" do
        answers.first.mark_as_the_best_answer!
        
        expect(answers.first).to be_best_answer 
      end

      it "false" do
        answers.first.mark_as_the_best_answer!
        answers.last.mark_as_the_best_answer!
        
        answers.first.reload

        expect(answers.first).not_to be_best_answer
      end
    end
    
    describe 'default order' do
      it "should display the best answer first" do
        answers.last.mark_as_the_best_answer!
        question.reload

        expect(question.answers).to eq([answers.last, answers.first])
      end
    end
  end
end
