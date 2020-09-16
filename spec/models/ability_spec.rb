require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user_id: user.id }
    let(:answer) { create :answer, user_id: user.id }
    let(:other_question) { create :question }
    let(:other_answer) { create :answer }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user_id: user.id) }
    it { should_not be_able_to :update, create(:question, user_id: other.id) }

    it { should be_able_to :update, create(:answer, user_id: user.id) }
    it { should_not be_able_to :update, create(:answer, user_id: other.id) }
    
    it { should be_able_to :destroy, create(:question, user_id: user.id) }
    it { should_not be_able_to :destroy, create(:question, user_id: other.id) }

    it { should be_able_to :destroy, create(:answer, user_id: user.id) }
    it { should_not be_able_to :destroy, create(:answer, user_id: other.id) }
    
    it { should be_able_to :mark_as_the_best, create(:answer, question_id: question.id) }
    it { should_not be_able_to :mark_as_the_best, create(:answer) }
    
    it { should be_able_to :vote_yes, create(:answer, user_id: other.id) }
    it { should_not be_able_to :vote_yes, create(:answer, user_id: user.id) }
    
    it { should be_able_to :vote_no, create(:answer, user_id: other.id) }
    it { should_not be_able_to :vote_no, create(:answer, user_id: user.id) }
    
    it { should be_able_to :cancel_vote, create(:answer, user_id: other.id) }
    it { should_not be_able_to :cancel_vote, create(:answer, user_id: user.id) }
    
    it { should be_able_to :destroy, create(:link, linkable: answer) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:answer)) }
    
    it { should be_able_to :destroy, question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain').first }
    it { should_not be_able_to :destroy, other_question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain').first }
    
    it { should be_able_to :destroy, answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain').first }
    it { should_not be_able_to :destroy, other_answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain').first }

    it { should be_able_to :create, create(:bounty, :with_image, question: question) }
    it { should_not be_able_to :create, create(:bounty, :with_image, question: other_question) }
    
    #it { should be_able_to :create, User }
  end
end
