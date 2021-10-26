require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:bounties) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:oauth_providers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
  
    it "should be true" do
      expect(question.user).to be_author_of(question)
      expect(answer.user).to be_author_of(answer)
    end

    it "should be false" do
      expect(user).not_to be_author_of(question)
      expect(user).not_to be_author_of(answer)
    end
  end

  describe '#voted_for?' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    it 'should be true' do
      user.votes.create(votable: answer.question)
      user.votes.create(votable: answer) 

      expect(user).to be_voted_for(answer.question)
      expect(user).to be_voted_for(answer)
    end

    it 'should be false' do
      expect(user).not_to be_voted_for(answer.question)
      expect(user).not_to be_voted_for(answer)
    end
  end
  
  describe '#vote_yes!' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    it 'should add question to votes collection' do
      question_vote = user.vote_yes!(answer.question)
      answer_vote = user.vote_yes!(answer)

      expect(user.votes).to include(question_vote)
      expect(user.votes).to include(answer_vote)
    end
  end

  describe '#vote_no!' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    it 'should add question to votes collection' do
      question_vote = user.vote_no!(answer.question)
      answer_vote = user.vote_no!(answer)

      expect(user.votes).to include(question_vote)
      expect(user.votes).to include(answer_vote)
    end
  end
  
  describe '#cancel_vote!' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    it 'should remove vote for the question from votes collection' do
      question_vote = user.cancel_vote!(answer.question)
      answer_vote = user.cancel_vote!(answer)

      expect(user.votes).to_not include(question_vote)
      expect(user.votes).to_not include(answer_vote)
    end
  end

  describe '.find_for_oauth' do
    context 'github' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
      let(:service) { double('Services::FindForOauth') }

      it 'calls Services::FindForOauth' do
        expect(Services::FindForOauth).to receive(:new).with(auth, nil).and_return(service)
        expect(service).to receive(:call)
        User.find_for_oauth(auth)
      end
    end

    context 'vkontakte' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }
      let(:service) { double('Services::FindForOauth') }

      it 'calls Services::FindForOauth' do
        expect(Services::FindForOauth).to receive(:new).with(auth, nil).and_return(service)
        expect(service).to receive(:call)
        User.find_for_oauth(auth)
      end
    end
  end

  describe '#subscribed_to?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
  
    it 'should be true' do
      user.subscriptions.create(question: question)

      expect(user).to be_subscribed_to(question)
    end

    it 'should be false' do
      expect(user).not_to be_subscribed_to(question)
    end
  end

  describe '#subscribe!' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'should add question to subscription list' do
      question_subscription = user.subscribe!(question)

      expect(user.subscriptions).to include(question_subscription)
    end
  end

  describe '#unsubscribe!' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'should remove question from subscription list' do
      question_subscription = user.subscribe!(question)
      user.unsubscribe!(question)

      expect(user.subscriptions).not_to include(question_subscription)
    end
  end
end
