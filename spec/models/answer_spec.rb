require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#mark_as_the_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    
    it "changes is_best to true" do
      answer.mark_as_the_best!
      
      expect(answer.is_best?).to be(true)
    end

    it "changes other's is_best to false" do
      answer.mark_as_the_best!
      other_answer = Answer.create(user: user, question: question, body: 'body 2')
      other_answer.mark_as_the_best!
      
      expect(answer.reload.is_best?).to be(false)
    end

  end
end
