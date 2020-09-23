require 'rails_helper'

describe Api::V1::Ability, type: :model do
  subject(:ability) { Api::V1::Ability.new(user) }
 
  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
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

    it { should be_able_to :update, create(:question, user_id: user.id) }
    it { should_not be_able_to :update, create(:question, user_id: other.id) }

    it { should be_able_to :update, create(:answer, user_id: user.id) }
    it { should_not be_able_to :update, create(:answer, user_id: other.id) }
    
    it { should be_able_to :destroy, create(:question, user_id: user.id) }
    it { should_not be_able_to :destroy, create(:question, user_id: other.id) }

    it { should be_able_to :destroy, create(:answer, user_id: user.id) }
    it { should_not be_able_to :destroy, create(:answer, user_id: other.id) }
    
    it { should be_able_to :me, user }
    it { should_not be_able_to :me, other }
    
    it { should be_able_to :others, other }
    it { should_not be_able_to :others, user }
  end
end
