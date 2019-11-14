require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#mark_as_the_best' do
    let(:user) { User.create(email: 'user@example.com', password: 'pwd123', password_confirmation: 'pwd123') }
    let(:question) { Question.create(title: 'title', body: 'Test question', user: user) }
    let(:answer) { Answer.create(user: user, question: question, body: 'body 1') }
    
    it "changes is_best to 1" do
      answer.mark_as_the_best
      
      expect(answer.is_best).to eq(1)
    end

    it "changes other's is_best to 0" do
      answer.mark_as_the_best
      other_answer = Answer.create(user: user, question: question, body: 'body 2')
      other_answer.mark_as_the_best
      
      expect(answer.reload.is_best).to eq(0)
    end

  end
end
