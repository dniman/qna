require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  
  include_examples 'linkable'
  include_examples 'votable'
  include_examples 'commentable'

  it { should validate_presence_of :body }

  it 'has one or many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
  
  context 'methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_bounty) }
    
    describe '#mark_as_the_best_answer!' do
      let(:answers) { create_list(:answer, 2, question: question) }
      
      it "true" do
        answers.first.mark_as_the_best_answer!
        
        expect(answers.first).to be_best_answer 
      end

      it 'should add bounty to user bounties collection' do
        answers.first.mark_as_the_best_answer!

        expect(answers.first.user.bounties).to include(answers.first.question.bounty)
      end

      it "false" do
        answers.first.mark_as_the_best_answer!
        answers.last.mark_as_the_best_answer!
        
        answers.first.reload

        expect(answers.first).not_to be_best_answer
      end
      
      it 'should remove bounty from user bounties collection' do
        answers.first.mark_as_the_best_answer!
        answers.last.mark_as_the_best_answer!
        
        answers.first.reload

        expect(answers.first.user.bounties).not_to include(answers.first.question.bounty)
      end
    end
    
    describe 'default order' do
      let(:answers) { create_list(:answer, 3, question: question) }

      it "should display the best answer first" do
        answers.last.mark_as_the_best_answer!
        question.reload

        expect(question.answers).to eq([answers.last, answers.first, answers[1]])
      end
    end

    describe "#notify_author_of_question" do
      let(:answer) { build(:answer) }

      it "calls NotifySubscribedUsersJob" do
        expect(NotifySubscribedUsersJob).to receive(:perform_later).with(answer)
        answer.save!
      end
    end
  end
end
